
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
from each student:

``` r
library(synthesizer)
data("students")
show(students)
#>               Name         Pref 1         Pref 2          Pref 3        Pref 4
#> 1     Adams, Caleb  Coleman, Zach     Price, Zoe     Hill, Mason   Hill, Mason
#> 2   Anderson, Maya   Patel, Arjun    Kim, Sophia    Lopez, Diego  Nguyen, Emma
#> 3      Baker, Owen Johnson, Grace   Parker, Ella            <NA>          <NA>
#> 4   Bennett, Chloe Turner, Olivia   Reed, Jordan   Brooks, Tyler          <NA>
#> 5    Brooks, Tyler   Reed, Jordan Turner, Olivia            <NA>          <NA>
#> 6      Chen, Ethan  Garcia, Elena    Wright, Ava    Singh, Priya  Murphy, Noah
#> 7    Coleman, Zach     Price, Zoe   Adams, Caleb            <NA>          <NA>
#> 8       Cook, Lily Turner, Olivia   Reed, Jordan    Parker, Ella          <NA>
#> 9    Davis, Harper  Martinez, Leo    White, Ruby     Wright, Ava          <NA>
#> 10   Flores, Lucas   Ortiz, Mateo Vasquez, Lucia            <NA> Martinez, Leo
#> 11    Foster, Liam Turner, Olivia  Brooks, Tyler      Price, Zoe          <NA>
#> 12   Garcia, Elena    Chen, Ethan    Wright, Ava    Singh, Priya  Murphy, Noah
#> 13 Gomez, Isabella  Rivera, Sofia Vasquez, Lucia            <NA>          <NA>
#> 14     Hill, Mason   Adams, Caleb     Price, Zoe    Patel, Arjun          <NA>
#> 15  Johnson, Grace    Baker, Owen   Parker, Ella    Nguyen, Emma          <NA>
#> 16     Kim, Sophia Anderson, Maya   Patel, Arjun            <NA>    Cook, Lily
#> 17    Lopez, Diego    Kim, Sophia Anderson, Maya   Scott, Nathan          <NA>
#> 18   Martinez, Leo  Davis, Harper    White, Ruby            <NA>          <NA>
#> 19    Murphy, Noah    Wright, Ava  Garcia, Elena   Flores, Lucas          <NA>
#> 20    Nguyen, Emma Anderson, Maya   Lopez, Diego      Cook, Lily          <NA>
#> 21    Ortiz, Mateo Vasquez, Lucia  Rivera, Sofia    Nguyen, Emma  Patel, Arjun
#> 22    Parker, Ella Johnson, Grace    Baker, Owen            <NA>          <NA>
#> 23    Patel, Arjun Anderson, Maya    Kim, Sophia   Flores, Lucas          <NA>
#> 24      Price, Zoe  Coleman, Zach   Adams, Caleb      Cook, Lily          <NA>
#> 25    Reed, Jordan  Brooks, Tyler Turner, Olivia    Nguyen, Emma   Hill, Mason
#> 26   Rivera, Sofia   Ortiz, Mateo Vasquez, Lucia            <NA>          <NA>
#> 27   Scott, Nathan     Cook, Lily Johnson, Grace  Bennett, Chloe          <NA>
#> 28    Singh, Priya    Chen, Ethan  Garcia, Elena Gomez, Isabella          <NA>
#> 29  Turner, Olivia   Reed, Jordan  Brooks, Tyler  Johnson, Grace  Parker, Ella
#> 30  Vasquez, Lucia   Ortiz, Mateo  Rivera, Sofia     Wright, Ava  Murphy, Noah
#> 31     White, Ruby  Martinez, Leo  Davis, Harper  Bennett, Chloe  Foster, Liam
#> 32     Wright, Ava  Garcia, Elena    Chen, Ethan   Flores, Lucas          <NA>
#>             Avoid Availability
#> 1   Brooks, Tyler           AB
#> 2    Reed, Jordan            A
#> 3            <NA>            B
#> 4   Brooks, Tyler           AB
#> 5     Kim, Sophia            A
#> 6            <NA>           AB
#> 7     Wright, Ava            B
#> 8            <NA>           AB
#> 9    Nguyen, Emma            A
#> 10           <NA>            B
#> 11     Price, Zoe           AB
#> 12           <NA>            A
#> 13  Brooks, Tyler           AB
#> 14           <NA>            B
#> 15  Brooks, Tyler           AB
#> 16  Brooks, Tyler            A
#> 17           <NA>            B
#> 18   Patel, Arjun           AB
#> 19           <NA>            A
#> 20    Hill, Mason            B
#> 21           <NA>           AB
#> 22  Scott, Nathan            A
#> 23           <NA>           AB
#> 24  Coleman, Zach            B
#> 25  Davis, Harper           AB
#> 26           <NA>            A
#> 27 Johnson, Grace            B
#> 28           <NA>           AB
#> 29           <NA>            A
#> 30           <NA>           AB
#> 31           <NA>            B
#> 32           <NA>           AB
```

``` r
teams <- syn_teams(students = students, time_limit = 1)
teams
#> # A tibble: 6 × 4
#>       t slot  members                                                       size
#>   <int> <chr> <chr>                                                        <int>
#> 1     1 B     Adams, Caleb, Hill, Mason, Price, Zoe                            3
#> 2     2 A     Chen, Ethan, Davis, Harper, Garcia, Elena, Murphy, Noah, Si…     6
#> 3     4 B     Bennett, Chloe, Coleman, Zach, Flores, Lucas, Martinez, Leo…     6
#> 4     5 A     Anderson, Maya, Johnson, Grace, Kim, Sophia, Ortiz, Mateo, …     6
#> 5     7 A     Brooks, Tyler, Cook, Lily, Foster, Liam, Parker, Ella, Reed…     6
#> 6    10 B     Baker, Owen, Gomez, Isabella, Lopez, Diego, Nguyen, Emma, V…     5
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
