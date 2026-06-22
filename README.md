
<!-- README.md is generated from README.Rmd. Please edit that file -->

# synthesizer

<!-- badges: start -->

<!-- badges: end -->

synthesizer helps instructors create collaborative project teams based
on student preferences and availability. The goal is to take make a
manual process easier by automatically considering and balancing
preferences and constraints.

This package is designed to facilitate one of the logistical challenges
of collaborative, project-based, and experiential learning–creating
project teams. Instead of randomly making teams, or enabling students to
entirely choose their teams, synthesizer provides instructors with a
streamlined way to account for student preferences. Students provide up
to 4 peers they’d prefer to work with, 1 peer they’d prefer not to work
with, and their availability for out-of-class meeting times based on 2
options.

syntheizer uses integer programming to create teams that optimize the
number of preferred student pairings, while ensuring students are not
put with non-preferred peers and that all team members are available at
the same time. This package aims to help instructors save time while
also ensuring teams are created with student input.

## Installation

You can install the development version of synthesizer from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("bgormally/synthesizer")
```

## Example

This is a basic example which shows how `syn_teams` generates
collaborative project teams based on the preferences and availability
from each student.

To use `syn_teams`, the data should be organized in columns as follows:
each student’s name; 1st preferred peer; 2nd preferred peer; 3rd
preferred peer; 4th preferred peer; peer to avoid; availability. If any
preferences or availability are not collected by the instructor, the
columns are still required but those cells should be left blank.

``` r
library(synthesizer)
data("students")
head(students)
#>             Name         Pref 1         Pref 2        Pref 3       Pref 4
#> 1   Adams, Caleb  Coleman, Zach     Price, Zoe   Hill, Mason  Hill, Mason
#> 2 Anderson, Maya   Patel, Arjun    Kim, Sophia  Lopez, Diego Nguyen, Emma
#> 3    Baker, Owen Johnson, Grace   Parker, Ella          <NA>         <NA>
#> 4 Bennett, Chloe Turner, Olivia   Reed, Jordan Brooks, Tyler         <NA>
#> 5  Brooks, Tyler   Reed, Jordan Turner, Olivia          <NA>         <NA>
#> 6    Chen, Ethan  Garcia, Elena    Wright, Ava  Singh, Priya Murphy, Noah
#>           Avoid Availability
#> 1 Brooks, Tyler           AB
#> 2  Reed, Jordan            A
#> 3          <NA>            B
#> 4 Brooks, Tyler           AB
#> 5   Kim, Sophia            A
#> 6          <NA>           AB
```

`syn_teams` generates a tibble data frame of each team, with maximized
preferences while ensuring students are not with non-preferred peers and
they share the same availability as their teammates.

``` r
teams <- syn_teams(students = students, time_limit = 0.1)
teams
#> # A tibble: 6 × 4
#>       t slot  members                                                       size
#>   <int> <chr> <chr>                                                        <int>
#> 1     1 A     Brooks, Tyler, Chen, Ethan, Foster, Liam, Garcia, Elena, Re…     6
#> 2     2 A     Gomez, Isabella, Murphy, Noah, Rivera, Sofia, Singh, Priya,…     6
#> 3     3 B     Coleman, Zach, Flores, Lucas, Lopez, Diego, Nguyen, Emma, S…     5
#> 4     4 B     Adams, Caleb, Baker, Owen, Hill, Mason, Johnson, Grace, Pri…     6
#> 5     5 A     Anderson, Maya, Bennett, Chloe, Cook, Lily, Kim, Sophia, Pa…     6
#> 6    10 A     Davis, Harper, Martinez, Leo, Ortiz, Mateo                       3
```
