#' Synthesize preferences and availability into teams
#'
#' This function uses integer programming from the `ompr` package. Each student
#' provides up to 4 peers who they would prefer working with and 1 peer they'd
#' like to avoid working with as well as their availability for 2 out-of-class meeting
#' times. These variables are stored in a data frame and `syn_teams` creates teams
#' that maximize preferences while avoiding non-preferences and ensuring shared
#' availability.
#'
#' @param students The data frame student preferences and availability are stored
#' @param min_size The minimum number of students per team
#' @param max_size The maximum number of students per team
#' @param preference_weight The weight of preferences
#' @param team_penalty Penalty for adding teams
#' @param time_limit Time limit in minutes
#'
#' @return A tibble dataframe of teams based on preferences and availability
#' @export
#'
#' @examples
#' library(synthesizer)
#' students <- read.csv("students.csv")
#' teams <- syn_teams(students)
#'
syn_teams <- function(
    students,
    min_size = 3, # change min/max size if you want more/less flexibility
    max_size = 6,
    preference_weight = 10,
    team_penalty = 2,
    time_limit = 2 # in minutes
    ) {
  library(ROI.plugin.glpk)

  # ------------------------------------------------------------
  # 1. Clean data
  # ------------------------------------------------------------
  students <- students |>
    dplyr::mutate(across(tidyselect::everything(), ~ dplyr::na_if(.x, "")))

  n <- nrow(students)
  student_names <- students$Name

  # Number of teams (flexible lower bound)
  T <- ceiling(n / min_size)

  # ------------------------------------------------------------
  # 2. Availability
  # ------------------------------------------------------------
  avail_A <- students$Availability %in% c("A", "AB")
  avail_B <- students$Availability %in% c("B", "AB")

  # ------------------------------------------------------------
  # 3. Preference matrix
  # ------------------------------------------------------------
  W <- matrix(0, n, n, dimnames = list(student_names, student_names))

  for (i in 1:n) {
    prefs <- unlist(students[i, c("Pref 1", "Pref 2", "Pref 3", "Pref 4")])
    prefs <- prefs[!is.na(prefs)]

    for (p in prefs) {
      j <- which(student_names == p)
      if (length(j) == 1) {
        W[i, j] <- W[i, j] + 1
      }
    }
  }

  W <- W + t(W)
  diag(W) <- 0

  # ------------------------------------------------------------
  # 4. Avoid pairs
  # ------------------------------------------------------------
  avoid_pairs <- list()

  for (i in 1:n) {
    if (!is.na(students$Avoid[i])) {
      j <- which(student_names == students$Avoid[i])
      if (length(j) == 1) {
        avoid_pairs[[length(avoid_pairs) + 1]] <- c(i, j)
      }
    }
  }

  # i = number of students
  # t = number of teams

  # ------------------------------------------------------------
  # 5. MODEL
  # ------------------------------------------------------------
  model <- ompr::MIPModel() |>
    # assignment variable
    ompr::add_variable(x[i, t], i = 1:n, t = 1:T, type = "binary") |>
    # team indicator (used for feasibility control)
    ompr::add_variable(active[t], t = 1:T, type = "binary") |>
    ompr::add_variable(team_A[t], t = 1:T, type = "binary") |>
    ompr::add_variable(team_B[t], t = 1:T, type = "binary") |>
    # co-membership variable
    ompr::add_variable(z[i, j, t], i = 1:(n - 1), j = (i + 1):n, t = 1:T, type = "binary")

  # --------------------------------------------------------
  # 6. Core constraints
  # --------------------------------------------------------
  # each student assigned exactly once
  model <- model |>
    ompr::add_constraint(sum_expr(x[i, t], t = 1:T) == 1, i = 1:n)

  # --------------------------------------------------------
  # 7. Team size = 3 - 6
  # --------------------------------------------------------

  model <- model |>
    ompr::add_constraint(
      sum_expr(x[i, t], i = 1:n) <= max_size * active[t],
      t = 1:T
    ) |>
    ompr::add_constraint(
      sum_expr(x[i, t], i = 1:n) >= min_size * active[t],
      t = 1:T
    )

  # ------------------------------------------------
  # 8. Active team chooses ONE availability
  # ------------------------------------------------

  model <- model |>
    ompr::add_constraint(
      team_A[t] + team_B[t] == active[t],
      t = 1:T
    )

  # --------------------------------------------------------
  # 9. Availability constraints
  # --------------------------------------------------------

  for (i in 1:n) {
    for (t in 1:T) {
      if (!avail_A[i]) {
        model <- model |>
          ompr::add_constraint(x[i, t] <= team_B[t])
      }

      if (!avail_B[i]) {
        model <- model |>
          ompr::add_constraint(x[i, t] <= team_A[t])
      }
    }
  }

  # --------------------------------------------------------
  # 10. Avoid constraints
  # --------------------------------------------------------

  for (pair in avoid_pairs) {
    i <- pair[1]
    j <- pair[2]

    model <- model |>
      ompr::add_constraint(
        x[i, t] + x[j, t] <= 1,
        t = 1:T
      )
  }

  # --------------------------------------------------------
  # 11. Linearization constraints
  # --------------------------------------------------------

  model <- model |>
    ompr::add_constraint(z[i, j, t] <= x[i, t], i = 1:(n - 1), j = (i + 1):n, t = 1:T) |>
    ompr::add_constraint(z[i, j, t] <= x[j, t], i = 1:(n - 1), j = (i + 1):n, t = 1:T) |>
    ompr::add_constraint(z[i, j, t] >= x[i, t] + x[j, t] - 1,
      i = 1:(n - 1), j = (i + 1):n, t = 1:T
    )

  # --------------------------------------------------------
  # 11. Maximize preferences
  # --------------------------------------------------------

  # Maximize preferences while adding a team penalty for adding additional teams

  # preference_weight <- 10
  # team_penalty <- 2

  model <- model |>
    ompr::set_objective(
      preference_weight *
        sum_expr(
          W[i, j] * z[i, j, t],
          i = 1:(n - 1),
          j = (i + 1):n,
          t = 1:T
        )

        -

        team_penalty *
          sum_expr(
            active[t],
            t = 1:T
          ),
      "max"
    )

  # --------------------------------------------------------
  # 12. Solve + extract
  # --------------------------------------------------------

  tm_limit <- time_limit * 60000

  result <- ompr::solve_model(model, ompr.roi::with_ROI(solver = "glpk", tm_limit = tm_limit))

  solution <- ompr::get_solution(result, x[i, t]) |>
    dplyr::filter(value == 1)

  if (nrow(solution) == 0) {
    stop("No feasible solution found. Try relaxing constraints (avoid/availability/team size).")
  }

  team_types <-
    dplyr::bind_rows(
      ompr::get_solution(result, team_A[t]) |>
        dplyr::mutate(slot = "A"),
      ompr::get_solution(result, team_B[t]) |>
        dplyr::mutate(slot = "B")
    ) |>
    dplyr::filter(value == 1)

  teams <- solution |>
    dplyr::mutate(student = student_names[i]) |>
    dplyr::left_join(
      team_types |>
        dplyr::select(t, slot),
      by = "t"
    ) |>
    dplyr::group_by(t, slot) |>
    dplyr::summarise(
      members = paste(student, collapse = ", "),
      size = dplyr::n(),
      .groups = "drop"
    )

  return(teams)
}
