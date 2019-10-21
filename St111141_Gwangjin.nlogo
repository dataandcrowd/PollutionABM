extensions [gis csv table]
globals [gu road land districtPop districtEdu districtadminCode %riskpop date where number-dead ts_kalman poll_scenario]
breed [dong-labels dong-label]
breed[people person]
patches-own [is-research-area? name dong-code land10 hospital ts__kal]
people-own  [health age edu districtName district-code
             homeName homePatch destinationName destinationPatch]

;;--------------------------------
to setup
 clear-all
 reset-ticks
 set-gis-data
 add-labels
 add-admin
 add-land
 add-census
 add-pollution
 set-dictionaries
 set-people
 set-destination
end
;;---------------------------------
to go
  calc-pm10
  landprice-change
  move-people
  ask people [
  inhalation
  ]
  go-hospital
  ask people [
    adaptive-cap
    sensitivity
    ;road-effect
    ]

  gu-plot
  dong-plot
  age-plot
  edu-plot
  pm10-plot
  update-plots
  tick
  if (ticks = 8764) [stop]
  set date item 0 table:get ts_kalman (ticks + 1)
  set where item 2 table:get ts_kalman (ticks + 1)
  set %riskpop    (count people with [color = red and destinationName != "others"] / count people with [destinationName != "others"]) * 100
  set number-dead count people with [health < 0]
end


;;--------------------------------
to set-gis-data
  ask patches [set pcolor white]
  gis:load-coordinate-system (word "boundary/boundary_shape/Gwangjin.prj")
  set gu   gis:load-dataset "boundary/boundary_shape/Gwangjin.shp"
  set road gis:load-dataset "roads/roads_shape/Gwangjin.shp"
  set land gis:load-dataset "LandPrice/LandPrice_Gu_Shape/Landprice_Gwangjin.shp"
  gis:set-world-envelope (gis:envelope-union-of gis:envelope-of gu)
  ask patches gis:intersecting gu [set is-research-area? true]
;;--------------------------------
  ;; Draw district
foreach gis:feature-list-of gu [ gu-feature ->
    gis:set-drawing-color scale-color green (gis:property-value gu-feature "ADM_CD") 1105053 1105067
    gis:fill gu-feature 0
  ]
  gis:set-drawing-color [  64  64  64]    gis:draw gu 1
  gis:set-drawing-color [255 0 0 100]    gis:draw road 1
end

;;--------------------------------
to add-labels
  foreach gis:feature-list-of gu [vector-feature ->
  let centroid gis:location-of gis:centroid-of vector-feature
       if not empty? centroid
      [ create-dong-labels 1
        [ set xcor item 0 centroid
          set ycor item 1 centroid
          set size 0
          set label-color blue
          set label gis:property-value vector-feature "ADM_NM"
        ]]]
end
;;--------------------------------
to add-admin
  gis:set-drawing-color blue
  foreach gis:feature-list-of gu [vector-feature ->
    ask patches[ if gis:intersects? vector-feature self [set name gis:property-value vector-feature "ADM_NM"
                                 set dong-code gis:property-value vector-feature "ADM_CD"]
 ]]
end
;;--------------------------------
to add-land
  gis:set-drawing-color blue
  foreach gis:feature-list-of land [vector-feature ->
    ask patches[ if gis:intersects? vector-feature self [set land10 gis:property-value vector-feature "pr10"
                                 ]
 ]]
end
;;--------------------------------
to add-census
  let rawCode csv:from-file "Census/census2010_age_5per.csv"
  let adCode table:make
  foreach rawCode [ code ->
         if item 1 code = "Gwangjin"
        [table:put adCode item 0 code list (item 1 code)(item 2 code) ]
        ]
end
;;--------------------------------
to add-pollution
; Import daily pollution
  let p0 csv:from-file "Pollution/St111141_Gwangjin.csv"
  let p1 remove-item 0 p0
  let rep 0
  set ts_kalman  table:make

  foreach p1 [ poll ->
  if item 2 poll = "pm10"
    [ let counter item 0 poll
      let the-rest remove-item 0 poll
      table:put ts_kalman counter the-rest
    ]
  ]
set rep rep + 1

  ask patches with [is-research-area? = true] [
    let homeID item (3 + random 13) table:get ts_kalman 1
    ifelse homeID > 0
    [set ts__kal  homeID][set ts__kal max table:get ts_kalman 1]
  ]


;;Scenarios
  let quarter csv:from-file "Scenarios/St111141_Gwangjin.csv"
  let q1 remove-item 0 quarter
  let looop 0
  set poll_scenario table:make

   foreach q1 [p ->
    if item 1 p = "pm10"
    [ let counter item 0 p
      let the-rest remove-item 0 p
      table:put poll_scenario counter the-rest]
  ]
  set looop looop + 1

end

;;;;;;;;;;;;;;;;;;;;;;;;;;
to set-dictionaries
  let csv-age csv:from-file "Census/census2010_age_5per.csv"
  set districtpop table:make
  set districtadminCode table:make

foreach csv-age [ code ->
  if item 1 code = "Gwangjin"
    [let age59 list (item 3 code) (item 4 code)
     let age1014 lput item 5 code age59
     let age1519 lput item 6 code age1014
     let age2024 lput item 7 code age1519
     let age2529 lput item 8 code age2024
     let age3034 lput item 9 code age2529
     let age3539 lput item 10 code age3034
     let age4044 lput item 11 code age3539
     let age4549 lput item 12 code age4044
     let age5054 lput item 13 code age4549
     let age5559 lput item 14 code age5054
     let age6064 lput item 15 code age5559
     let age6569 lput item 16 code age6064
     let age7074 lput item 17 code age6569
     let age7579 lput item 18 code age7074
     let age85ov lput item 19 code age7579

     table:put districtpop item 2 code age85ov
     table:put districtadminCode item 2 code item 0 code
    ]
  ]


 let csv-edu csv:from-file "Census/census2010_edu_frac.csv"
  set districtEdu table:make

  foreach csv-edu [ code ->
    if item 0 code = "Gwangjin"
    [let primary list (item 2 code)(item 3 code)
     let middle  lput item 4 code primary
     let high    lput item 5 code middle
     let college lput item 6 code high
     let univ    lput item 7 code college
     let master  lput item 8 code univ
     let phd     lput item 9 code master

     table:put districtEdu item 1 code phd
    ]
  ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;
to set-people
  foreach table:keys districtpop [ dist ->
    let ageGroupID 0
    foreach table:get districtpop dist [ number ->
      create-people number [
        setupAgeGroup agegroupID
        set districtName dist
        set district-code table:get districtadminCode dist
        set shape "person"
        set heading random 360
        set homeName dist
        set homePatch one-of patches with [dong-code = [district-code] of myself ]
        move-to homePatch
        set destinationName "unidentified"
        set destinationPatch "unidentified"
        set health 300
        ;set age-counter 1 + random 730
      ]
      set ageGroupID AgeGroupID + 1
      ]
  ]
end

to setupAgeGroup [ID]
if ID = 0  [set size 1 set age  5 + random 5 set color orange
            ifelse random-float 1 <= .19 [set edu 0][set edu 1]]
if ID = 1  [set size 1 set age 10 + random 5 set color orange + 1
            ifelse random-float 1 <= .53 [set edu 1][set edu 2]]
if ID = 2  [set size 1 set age 15 + random 5 set color orange + 2
            let r random-float 1
            if (0    < r and r <= 0.14)[set edu 2]
            if (0.14 < r and r <= 0.77)[set edu 3]
            if (0.77 < r and r <= 0.85)[set edu 4]
            if (0.85 < r )[set edu 5]]
if ID = 3  [set size 1 set age 20 + random 5 set color turquoise
            let r random-float 1
            if (0    < r and r <= 0.13)[set edu 3]
            if (0.13 < r and r <= 0.40)[set edu 4]
            if (0.40 < r and r <= 0.98)[set edu 5]
            if (0.98 < r )[set edu 6]]
if ID = 4  [set size 1 set age 25 + random 5 set color turquoise
            let r random-float 1
            if (0    < r and r <= 0.01)[set edu 2]
            if (0.01 < r and r <= 0.16)[set edu 3]
            if (0.16 < r and r <= 0.41)[set edu 4]
            if (0.41 < r and r <= 0.92)[set edu 5]
            if (0.92 < r )[set edu 6]]
if ID = 5  [set size 1 set age 30 + random 5 set color turquoise
            let r random-float 1
            if (0    < r and r <= 0.01)[set edu 2]
            if (0.01 < r and r <= 0.22)[set edu 3]
            if (0.22 < r and r <= 0.44)[set edu 4]
            if (0.44 < r and r <= 0.90)[set edu 5]
            if (0.90 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 6  [set size 1 set age 35 + random 5 set color turquoise
            let r random-float 1
            if (0    < r and r <= 0.02)[set edu 2]
            if (0.02 < r and r <= 0.37)[set edu 3]
            if (0.37 < r and r <= 0.54)[set edu 4]
            if (0.54 < r and r <= 0.90)[set edu 5]
            if (0.90 < r and r <= 0.98)[set edu 6]
            if (0.98 < r )[set edu 7]]
if ID = 7  [set size 1 set age 40 + random 5 set color brown
            let r random-float 1
            if (0    < r and r <= 0.01)[set edu 1]
            if (0.01 < r and r <= 0.06)[set edu 2]
            if (0.06 < r and r <= 0.50)[set edu 3]
            if (0.50 < r and r <= 0.62)[set edu 4]
            if (0.62 < r and r <= 0.92)[set edu 5]
            if (0.92 < r and r <= 0.98)[set edu 6]
            if (0.98 < r )[set edu 7]]
if ID = 8  [set size 1 set age 45 + random 5 set color brown
            let r random-float 1
            if (0    < r and r <= 0.04)[set edu 1]
            if (0.04 < r and r <= 0.14)[set edu 2]
            if (0.14 < r and r <= 0.60)[set edu 3]
            if (0.60 < r and r <= 0.69)[set edu 4]
            if (0.69 < r and r <= 0.94)[set edu 5]
            if (0.94 < r and r <= 0.98)[set edu 6]
            if (0.98 < r )[set edu 7]]
if ID = 9  [set size 1 set age 50 + random 5 set color brown
            let r random-float 1
            if (0    < r and r <= 0.01)[set edu 0]
            if (0.01 < r and r <= 0.08)[set edu 1]
            if (0.08 < r and r <= 0.24)[set edu 2]
            if (0.24 < r and r <= 0.70)[set edu 3]
            if (0.70 < r and r <= 0.77)[set edu 4]
            if (0.77 < r and r <= 0.95)[set edu 5]
            if (0.95 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 10 [set size 1 set age 55 + random 5 set color brown
            let r random-float 1
            if (0    < r and r <= 0.01)[set edu 0]
            if (0.01 < r and r <= 0.14)[set edu 1]
            if (0.14 < r and r <= 0.34)[set edu 2]
            if (0.34 < r and r <= 0.76)[set edu 3]
            if (0.76 < r and r <= 0.81)[set edu 4]
            if (0.81 < r and r <= 0.96)[set edu 5]
            if (0.96 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 11 [set size 1 set age 60 + random 5 set color violet
            let r random-float 1
            if (0    < r and r <= 0.02)[set edu 0]
            if (0.02 < r and r <= 0.22)[set edu 1]
            if (0.22 < r and r <= 0.44)[set edu 2]
            if (0.44 < r and r <= 0.81)[set edu 3]
            if (0.81 < r and r <= 0.84)[set edu 4]
            if (0.84 < r and r <= 0.97)[set edu 5]
            if (0.97 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 12 [set size 1 set age 65 + random 5 set color violet
            let r random-float 1
            if (0    < r and r <= 0.05)[set edu 0]
            if (0.05 < r and r <= 0.32)[set edu 1]
            if (0.32 < r and r <= 0.53)[set edu 2]
            if (0.53 < r and r <= 0.82)[set edu 3]
            if (0.82 < r and r <= 0.85)[set edu 4]
            if (0.85 < r and r <= 0.97)[set edu 5]
            if (0.97 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 13 [set size 1 set age 70 + random 5 set color violet
            let r random-float 1
            if (0    < r and r <= 0.10)[set edu 0]
            if (0.10 < r and r <= 0.42)[set edu 1]
            if (0.42 < r and r <= 0.60)[set edu 2]
            if (0.60 < r and r <= 0.82)[set edu 3]
            if (0.82 < r and r <= 0.86)[set edu 4]
            if (0.86 < r and r <= 0.98)[set edu 5]
            if (0.98 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 14 [set size 1 set age 75 + random 5 set color violet
            let r random-float 1
            if (0    < r and r <= 0.19)[set edu 0]
            if (0.19 < r and r <= 0.56)[set edu 1]
            if (0.56 < r and r <= 0.69)[set edu 2]
            if (0.69 < r and r <= 0.86)[set edu 3]
            if (0.86 < r and r <= 0.89)[set edu 4]
            if (0.89 < r and r <= 0.98)[set edu 5]
            if (0.98 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]
if ID = 15 [set size 1 set age 80 + random 5 set color pink
            let r random-float 1
            if (0    < r and r <= 0.28)[set edu 0]
            if (0.28 < r and r <= 0.66)[set edu 1]
            if (0.66 < r and r <= 0.78)[set edu 2]
            if (0.78 < r and r <= 0.89)[set edu 3]
            if (0.89 < r and r <= 0.92)[set edu 4]
            if (0.92 < r and r <= 0.98)[set edu 5]
            if (0.98 < r )[set edu 6]]
if ID = 16 [set size 1 set age 85 + random 15 set color pink
            let r random-float 1
            if (0    < r and r <= 0.44)[set edu 0]
            if (0.44 < r and r <= 0.77)[set edu 1]
            if (0.77 < r and r <= 0.86)[set edu 2]
            if (0.86 < r and r <= 0.93)[set edu 3]
            if (0.93 < r and r <= 0.94)[set edu 4]
            if (0.94 < r and r <= 0.98)[set edu 5]
            if (0.98 < r and r <= 0.99)[set edu 6]
            if (0.99 < r )[set edu 7]]

end

;;;;;;;;;;;;;;;;;;;;;
to set-destination   ;; Decomposing matrix
  let gncsv csv:from-file "ODmatrix/St111141_Gwangjin.csv"
  let rawheader item 0 gncsv
  let destinationNames remove-item 0 rawheader
  let gnMat remove-item 0 gncsv

  let loopnum 1
  let gnMatrix table:make ;; This is a matrix where each origin has its name as a "key"
  foreach gnMat [ origin-chart ->
    let numberMat remove-item 0 origin-chart    ;; fraction has to be btw 0-1,
    let fraction map [ i -> i / 100 ] numberMat ;; but the original file is btw 1-100
    table:put gnMatrix item 0 origin-chart fraction
                 ]
  set loopnum loopnum + 1

  foreach table:keys gnMatrix [ originName ->
    let matrix-loop 0
    let Num count people with [homeName = originName and (age >= 15 and age < 65)]
    let totalUsed 0
    let number 0

	foreach table:get gnMatrix originName
       [ percent ->
          let newDestination item matrix-loop destinationNames ;; Let agents of 22 origins choose their destinations
          ifelse (newDestination != "others") [set number precision (percent * Num) 0 set totalUsed totalUsed + number]
              [set number Num - totalUsed ]
		  ;; if agents move within district, then count agents by rounding the values of population x
      ;; "fraction of region A", population x "fraction of region B"...
      ;; if agents move outside district, then count the remainder of the population not used for inbound population
         let peopleRemaining (people with [homeName = originName and destinationName = "unidentified"
                and (age >= 15 and age < 65)])
         if count peopleRemaining > 0 and count peopleRemaining <= number [ set number count peopleRemaining ]
               if number < 0 [ set number 0]

         ask n-of number peopleRemaining [
                set destinationName newDestination ;; assign destination name
                set destinationPatch one-of patches with [name = newDestination]
       ]
    set matrix-loop matrix-loop + 1
  ]
  type totalused type " " type Num type " " print originName ;; print inbound agents out of the total population (age 15-64)
  ]



;; Send agents selected as "others" to the NE corner
 ask people [ if destinationName = "others"
             [ set destinationPatch patch max-pxcor max-pycor]
             ]

 ask people with [destinationpatch = "unidentified" and age < 15]
                 [set destinationName homeName
                  set destinationPatch one-of patches in-radius 3] ;; Under 15
 ask people with [destinationpatch = "unidentified" and age >= 65]
                 [set destinationName homeName
                  set destinationPatch one-of patches in-radius 1] ;; Over 65

 output-print "People without destinations(nobody)"
 let wordloop 0
 foreach destinationNames [ dn ->
    output-print word (word(word (word dn ": ") count people with
    [homename = dn and destinationPatch = nobody] ) " out of " ) count people with
    [homename = dn ]
       ]
 set wordloop wordloop + 1

end


to set-at-hospital
  ask patch min-pxcor min-pycor [set pcolor grey + 1]
  ;ask patches with [ count neighbors with [pcolor = grey + 1] = 8 ][set pcolor grey + 1 set hospital "true"]
end


;;;;;;;;;;;;;;;;;;
to go-hospital
  ask people [if (health <= 0) [move-to patch min-pxcor min-pycor fd 1]]
    ;move-to one-of patches with [pcolor = grey + 1] fd 1]];
end

to move-people
  ifelse ticks mod 2 = 0 [move-out][come-home]

end

to move-out
  ask people [if patch-here != destinationPatch [ move-to destinationPatch fd 1]
  ]
end

to come-home
  ask people [
    if patch-here != homePatch [move-to homePatch fd 1]
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;
to adaptive-cap
  if (health < AC) and ([land10] of patch-here  < 920459)  [set health health + 0.01]
  if (health < AC) and ([land10] of patch-here >= 920459)   and ([land10] of patch-here < 1550940) [set health health + 0.01]
  if (health < AC) and ([land10] of patch-here >= 1550940)  and ([land10] of patch-here < 2091133) [set health health + 0.02]
  if (health < AC) and ([land10] of patch-here >= 2091133)  and ([land10] of patch-here < 2637070) [set health health + 0.04]
  if (health < AC) and ([land10] of patch-here >= 2637070)  and ([land10] of patch-here < 3273274) [set health health + 0.05]
  if (health < AC) and ([land10] of patch-here >= 3273274)  and ([land10] of patch-here < 4140183) [set health health + 0.05]
  if (health < AC) and ([land10] of patch-here >= 4140183)  and ([land10] of patch-here < 5443608) [set health health + 0.06]
  if (health < AC) and ([land10] of patch-here >= 5443608)  and ([land10] of patch-here < 8361806) [set health health + 0.07]
  if (health < AC) and ([land10] of patch-here >= 8361806)  and ([land10] of patch-here < 11545447) [set health health + 0.12]
  if (health < AC) and ([land10] of patch-here >= 11545447) and ([land10] of patch-here < 20261596) [set health health + 0.15]

end
;;;;;;;;;;;;;;;;;;;;;;;;;;
to inhalation
  ifelse ([road] of patch-here = true)[road-effect] [non-road-effect]

end
;;;;;;;;;;;;;;;;;;;;;;;;;;
to sensitivity
  if (ts__kal >= PM10-parameters) and (health < 300) and ((age >= 65) or (age < 15 or edu < 1 + random 3))
     [set health (health - random-float 0.004 * (310 - health))]
  if (health < 200 and health >= 100) [set color violet]
  if (health < 100) [set color red]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;
to non-road-effect
  if(ts__kal >= PM10-parameters)
     [set health health - random-float 0.008 * (310 - health)] ;arbitrarily
end
;;;;;;;;;;;;;;;;;;;;;;;;;;
to road-effect
  if(ts__kal * 1.426 >= PM10-parameters)
     [set health health - random-float 0.010 * (310 - health)] ;arbitrarily
end

;;;;;;;;;;;;;;;;;;;;;;;;;;
to calc-pm10
  if (Scenario = "BAU")
  [ask patches with [is-research-area? = true]
   [if ticks > 0 [set-BAU]
  ]]

    if (Scenario = "INC")
  [ask patches with [is-research-area? = true]
    [
     if ticks > 0 and ticks <= 4382 [set-BAU]
     if ticks > 4382 [set-INC&DEC]
    ]
  ]

  if (Scenario = "DEC")
  [ask patches with [is-research-area? = true]
    [
     if ticks > 0 and ticks <= 4382 [set-BAU]
     if ticks > 4382 [set-INC&DEC]
    ]
  ]
end

to set-BAU
  let homeID item (3 + random 13) table:get ts_kalman ticks + 1
  let workID item (3 + random 11) table:get ts_kalman ticks + 1

   if (ticks + 1) mod 2 = 0 [
    ifelse homeID > 0
    [set ts__kal  homeID][set ts__kal max table:get ts_kalman ticks + 1]
  ]
   if ticks mod 2 = 0 [
    ifelse workID > 0
    [set ts__kal  workID][set ts__kal max table:get ts_kalman ticks + 1]
  ]

end

to set-INC&DEC
  let homeID item (3 + random 13) table:get ts_kalman ticks + 1
  let workID item (3 + random 11) table:get ts_kalman ticks + 1

  let %3inc 5
  if scenario-percent = "inc-sce" [set %3inc %3inc]
  if scenario-percent = "dec-sce" [set %3inc %3inc + 1]

     if ticks > 4382 and ticks <= 4562 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 1)]
     if ticks > 4562 and ticks <= 4744 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 2)]
     if ticks > 4744 and ticks <= 4850 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 3)]
     if ticks > 4850 and ticks <= 5112 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 4)]
     if ticks > 5112 and ticks <= 5292 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 5)]
     if ticks > 5292 and ticks <= 5474 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 6)]
     if ticks > 5474 and ticks <= 5658 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 7)]
     if ticks > 5658 and ticks <= 5842 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 8)]
     if ticks > 5842 and ticks <= 6024 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 9)]
     if ticks > 6024 and ticks <= 6206 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 10)]
     if ticks > 6206 and ticks <= 6390 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 11)]
     if ticks > 6390 and ticks <= 6574 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 12)]
     if ticks > 6574 and ticks <= 6754 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 13)]
     if ticks > 6754 and ticks <= 6936 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 14)]
     if ticks > 6936 and ticks <= 7120 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 15)]
     if ticks > 7120 and ticks <= 7304 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 16)]
     if ticks > 7304 and ticks <= 7484 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 17)]
     if ticks > 7484 and ticks <= 7666 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 18)]
     if ticks > 7666 and ticks <= 7850 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 19)]
     if ticks > 7850 and ticks <= 8034 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 20)]
     if ticks > 8034 and ticks <= 8214 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 21)]
     if ticks > 8214 and ticks <= 8396 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 22)]
     if ticks > 8396 and ticks <= 8580 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 23)]
     if ticks > 8580 and ticks <= 8764 and ticks mod 2 = 0 [set ts__kal workID + (item %3inc table:get poll_scenario 24)]

     if ticks > 4382 and ticks <= 4562 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 1)]
     if ticks > 4562 and ticks <= 4744 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 2)]
     if ticks > 4744 and ticks <= 4850 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 3)]
     if ticks > 4850 and ticks <= 5112 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 4)]
     if ticks > 5112 and ticks <= 5292 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 5)]
     if ticks > 5292 and ticks <= 5474 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 6)]
     if ticks > 5474 and ticks <= 5658 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 7)]
     if ticks > 5658 and ticks <= 5842 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 8)]
     if ticks > 5842 and ticks <= 6024 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 9)]
     if ticks > 6024 and ticks <= 6206 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 10)]
     if ticks > 6206 and ticks <= 6390 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 11)]
     if ticks > 6390 and ticks <= 6574 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 12)]
     if ticks > 6574 and ticks <= 6754 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 13)]
     if ticks > 6754 and ticks <= 6936 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 14)]
     if ticks > 6936 and ticks <= 7120 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 15)]
     if ticks > 7120 and ticks <= 7304 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 16)]
     if ticks > 7304 and ticks <= 7484 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 17)]
     if ticks > 7484 and ticks <= 7666 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 18)]
     if ticks > 7666 and ticks <= 7850 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 19)]
     if ticks > 7850 and ticks <= 8034 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 20)]
     if ticks > 8034 and ticks <= 8214 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 21)]
     if ticks > 8214 and ticks <= 8396 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 22)]
     if ticks > 8396 and ticks <= 8580 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 23)]
     if ticks > 8580 and ticks <= 8764 and (ticks + 1) mod 2 = 0 [set ts__kal homeID + (item %3inc table:get poll_scenario 24)]
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to landprice-change
  ask patches with [land10 >= 0][set land10 (random-float .1 + land10)]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to gu-plot
  set-current-plot "District level"
  set-current-plot-pen "risky"     plot ((count people with [color = violet + 2 and destinationName != "others"]) /
                                        (count people with [destinationName != "others"]) * 100)
  set-current-plot-pen "dangerous" plot ((count people with [color = red and destinationName != "others"]) /
                                        (count people with [ destinationName != "others"]) * 100)
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to dong-plot
  set-current-plot "Subdistrict level"
	set-current-plot-pen "Gunja_risk"     plot((count people with [color = red and districtName = "Gunja" and destinationName != "others"])   / (count people with [districtName = "Gunja" and destinationName != "others"])    * 100)
	set-current-plot-pen "Gui1_risk"  	plot((count people with [color = red and districtName = "Gui1" and destinationName != "others"])/ (count people with [districtName = "Gui1" and destinationName != "others"]) * 100)
	set-current-plot-pen "Gui2_risk"  plot((count people with [color = red and districtName = "Gui2" and destinationName != "others"])/ (count people with [districtName = "Gui2" and destinationName != "others"]) * 100)
	set-current-plot-pen "Gui3_risk"  plot((count people with [color = red and districtName = "Gui3" and destinationName != "others"])/ (count people with [districtName = "Gui3" and destinationName != "others"]) * 100)
	set-current-plot-pen "Gwangjang_risk"  plot((count people with [color = red and districtName = "Gwangjang" and destinationName != "others"])/ (count people with [districtName = "Gwangjang" and destinationName != "others"]) * 100)
	set-current-plot-pen "Hwayang_risk"   plot((count people with [color = red and districtName = "Hwayang" and destinationName != "others"]) / (count people with [districtName = "Hwayang" and destinationName != "others"])  * 100)
	set-current-plot-pen "Jayang1_risk"   plot((count people with [color = red and districtName = "Jayang1" and destinationName != "others"]) / (count people with [districtName = "Jayang1" and destinationName != "others"])  * 100)
	set-current-plot-pen "Jayang2_risk"  plot((count people with [color = red and districtName = "Jayang2" and destinationName != "others"])/ (count people with [districtName = "Jayang2" and destinationName != "others"]) * 100)
	set-current-plot-pen "Jayang3_risk"  plot((count people with [color = red and districtName = "Jayang3" and destinationName != "others"])/ (count people with [districtName = "Jayang3" and destinationName != "others"]) * 100)
	set-current-plot-pen "Jayang4_risk"    plot((count people with [color = red and districtName = "Jayang4" and destinationName != "others"])  / (count people with [districtName = "Jayang4" and destinationName != "others"])   * 100)
	set-current-plot-pen "Junggok1_risk"    plot((count people with [color = red and districtName = "Junggok1" and destinationName != "others"])  / (count people with [districtName = "Junggok1" and destinationName != "others"])   * 100)
	set-current-plot-pen "Junggok2_risk"    plot((count people with [color = red and districtName = "Junggok2" and destinationName != "others"])  / (count people with [districtName = "Junggok2" and destinationName != "others"])   * 100)
	set-current-plot-pen "Junggok3_risk"    plot((count people with [color = red and districtName = "Junggok3" and destinationName != "others"])  / (count people with [districtName = "Junggok3" and destinationName != "others"])   * 100)
	set-current-plot-pen "Junggok4_risk"     plot((count people with [color = red and districtName = "Junggok4" and destinationName != "others"])   / (count people with [districtName = "Junggok4" and destinationName != "others"])    * 100)
	set-current-plot-pen "Neungdong_risk"    plot((count people with [color = red and districtName = "Neungdong" and destinationName != "others"])  / (count people with [districtName = "Neungdong" and destinationName != "others"])   * 100)

end

to age-plot
  set-current-plot "By Age Group"
  set-current-plot-pen "Young"  plot(count people with [age < 15 and color = red and destinationName != "others"]) / (count people with [age < 15 and destinationName != "others"]) * 100
  set-current-plot-pen "Middle" plot((count people with [age >= 15 and age < 65 and color = red and destinationName != "others"]) / (count people with [age >= 15 and age < 65 and destinationName != "others"]) * 100)
  set-current-plot-pen "Old"    plot((count people with [age >= 65 and color = red and destinationName != "others"]) / (count people with [age >= 65 and destinationName != "others"]) * 100)

end

to edu-plot
  set-current-plot "By Education"
  set-current-plot-pen "High" plot((count people with [edu >= 3 and color = red and destinationName != "others"]) / (count people with [edu >= 3 and destinationName != "others"]) * 100)
  set-current-plot-pen "Low"  plot((count people with [edu < 3 and color = red and destinationName != "others"]) / (count people with [edu < 3 and destinationName != "others"]) * 100)

end

to pm10-plot
  set-current-plot "PM10 patches"
  set-current-plot-pen "pm10-Neungdong"  plot [ts__kal] of patch 72 96
end
@#$#@#$#@
GRAPHICS-WINDOW
527
55
746
295
-1
-1
1.25
1
10
1
1
1
0
0
0
1
0
168
0
184
1
1
1
half day
30.0

BUTTON
15
50
98
83
1.Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
15
86
98
119
2. Go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

CHOOSER
123
79
215
124
AC
AC
100 150 200
0

PLOT
179
187
339
307
Subdistrict level
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Gunja_risk" 1.0 0 -7500403 true "" ""
"Gui1_risk" 1.0 0 -2674135 true "" ""
"Gui2_risk" 1.0 0 -955883 true "" ""
"Gui3_risk" 1.0 0 -6459832 true "" ""
"Gwangjang_risk" 1.0 0 -1184463 true "" ""
"Hwayang_risk" 1.0 0 -10899396 true "" ""
"Jayang1_risk" 1.0 0 -13840069 true "" ""
"Jayang2_risk" 1.0 0 -14835848 true "" ""
"Jayang3_risk" 1.0 0 -11221820 true "" ""
"Jayang4_risk" 1.0 0 -13791810 true "" ""
"Junggok1_risk" 1.0 0 -13345367 true "" ""
"Junggok2_risk" 1.0 0 -8630108 true "" ""
"Junggok3_risk" 1.0 0 -5825686 true "" ""
"Junggok4_risk" 1.0 0 -2064490 true "" ""
"Neungdong_risk" 1.0 0 -14454117 true "" ""

PLOT
10
187
170
307
District level
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"risky" 1.0 0 -8630108 true "" ""
"dangerous" 1.0 0 -2674135 true "" ""

PLOT
10
317
170
437
By Age Group
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Young" 1.0 0 -955883 true "" ""
"Middle" 1.0 0 -14835848 true "" ""
"Old" 1.0 0 -6459832 true "" ""

PLOT
180
317
340
437
By Education
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"High" 1.0 0 -13345367 true "" ""
"Low" 1.0 0 -4699768 true "" ""

TEXTBOX
669
29
866
48
Gwangjin
18
0.0
1

TEXTBOX
107
43
245
89
*Adaptive Capacity Change
14
0.0
1

TEXTBOX
242
55
333
73
*PM10 Trend
14
0.0
1

MONITOR
17
127
89
172
NIL
%riskpop
17
1
11

MONITOR
94
127
186
172
Date
date
17
1
11

MONITOR
190
127
259
172
Location
where
17
1
11

PLOT
348
187
510
307
PM10 patches
time
pm10
0.0
10.0
0.0
200.0
true
false
"" ""
PENS
"pm10-Neungdong" 1.0 0 -6459832 true "" ""

CHOOSER
240
77
332
122
Scenario
Scenario
"BAU" "INC" "DEC"
0

OUTPUT
350
317
511
436
12

CHOOSER
267
126
391
171
PM10-parameters
PM10-parameters
50 80 100 150
2

MONITOR
399
128
465
173
Hospital
number-dead
17
1
11

CHOOSER
358
72
496
117
scenario-percent
scenario-percent
"inc-sce" "dec-sce"
0

@#$#@#$#@
## WHAT IS IT?
**SIMULATING PEDESTRIAN EXPOSURE TO AMBIENT URBAN AIR POLLUION**

The model’s objective is to understand the cumulative effects on the population’s vulnerability as represented by exposure to PM10 (particulate matter with diameter less than 10 micrometres) by different age and educational groups in Gangnam. Using this model, readers can explore individual's daily commuting routine, and its health loss when the PM10 concentration of the current patch breaches the national limit.

The model is initialised with a starting population with no previous exposure, in other words every agents have health of 300 in the beginning. This is because we couldn't find reliable references or statistics to access individual health reports.

## HOW IT WORKS
*Number of agents*. We used a 1% sample of Gangnam's total population, which was retrieved from the census website, rounded to a total of 5050 agents waiting for simulation. Agents aged under 15 are coloured in orange, between 15 and 64 are in turquoise, and over 65 in brown.

*Set destination*. During the setup process, every agent is assigned a fixed home name (sub-district) and home patch as well as their destination name and patch. In addition, agents will have their destination names and patches but differ by age groups. Agents between *age 15 and 65*, so called the economically active population, will move to their destination patches according to the fraction in the origin-destination (OD) matrix. Those who commute to other districts are assigned as *others*, and are allocated to patches outside Gangnam during working hours. Agents *aged under 15* will move to a random patch within 3 radius, while those *aged over 65* will move to a random patch within 1 radius. Given that the model is a simplified version, the model was designed to move agents in two phases: move-out and come-home.

*Health loss*. With initial health of 300, each agent will be located within their residential patch and be exposed to the patches at which they are stepping on. When the model activates, agents will move back and forth to their home destination patches. An agent will lose health when  exposed to a patch exceeding the PM10 concentration of 50, 100, or 150 μg/m3. Once the agent's health goes below 200, its colour will change to violet, then to red when it goes below 100. While the district plot captures both agents coloured in violet and red, the other plots capture agents only coloured in red. Even without pollution, people's health naturally aggravate over time, depending on age groups. Indeed, this model is not designed to kill people due to a short simulation period of 6 years. However, the interest here is to investigate health variances between groups and sub-regions.

*Health recovery* There is also a recovery mode that heals people's health. We selected land price as a representative factor for remedy. We assumed that hospitals and clinics in Seoul locate in costly areas, which therefore creates better opportunities to nearby residents to visit the doctor when needed.

*Expected outcomes*. This model expects four different outcomes. First plot is the total percentage of risk population in Gangnam. Second plot is the total percentage of risk population by subdistrict level. Third plot is the total percentage of risk population by age groups, followed by the last plot by education groups.

*Simulation time*. The model estimates the dynamic change (vulnerability) of the risk population by socioeconomic factors, and district for 6 years (4381 ticks) for which we have pollution data.


## HOW TO USE IT
**SIMPLE**: Press setup and go to run the model. The model would not stop until the total risk population exceeds 90% or the calendar date reaches the 31st of December 2015. If you would like to know the background information, keep on reading!

### Setup
*GIS DATA*: We imported GIS data of administrative boundary, road networks, land price, and a daily-mean interpolation map of PM10 all in ASCII format.

*ATTRIBUTE DATA*: We imported attributes from the 2010 Korean census of Gangnam in sub-district level by age and education status. Also, daily pollution statistics, provided by the national institution for environmental research (NIER), were cleaned and aggregated to office and home hours. We defined office hours from 9am to 7pm, and the remainder to home hours. For atmospheric settings, each patch contains its own daily average value of PM10 in the beginning, and changes its value over time according to its daily pollution statistics.

### Parameter settings
*AC*: These scenarios impose “adaptive capacity” on the maximum health for the whole population of 100, 150, and 200. Compared to scenario 100, scenario 200 means that the population has more capacity to accumulate resilience when pollution levels remain low.

*Scenario*: The pollution scenario consists of 3 types: business as usual (BAU), assuming the pollution trend as per the statistics continues for 6 years; increase (INC), where an addition of 15% of BAU is added everyday; and decrease (DEC), an 15% of BAU is degraded everyday.

*PM10 parameter*: We chose parameters to correspond different daily standards in various countries, where EU/UK in 50μg/m3, South Korea in 100μg/m3, and US in 100μg/m3.

### Monitors
*%riskpop* counts the total population coloured in red
*Date*: Actual date of pollution provided
*Where* is the current location of agents

## THINGS TO NOTICE
One tick is a half a day.
Agents will jump to their destinations and origins.
Agents who are assigned as *others* are inter-district commuters, but move to the far east corner for simplicity.
## THINGS TO TRY
Use different PM10 parameters and see the temporal difference.
Apply Scenarios.


## EXTENDING THE MODEL
We are planning to combine this model to a traffic model that takes into account exposures to tailpipe emission.

## NETLOGO FEATURES
(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS
UrbanSuite - Pollution

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
