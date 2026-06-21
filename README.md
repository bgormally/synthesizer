
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

This is a basic example which shows you how to solve a common problem:

``` r
library(synthesizer)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
