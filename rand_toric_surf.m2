
{*loadPackage "Polyhedra"*}
loadPackage "NormalToricVarieties"

{*Note, zip doesn't quite have the right semantics if the lists have different lengths*}
zip := (l1,l2) -> pack(2,mingle(l1,l2))
unzip := lst -> (apply(lst,val->val#0),apply(lst,val->val#1))
circularPairList := lst -> pack(2,drop(append(mingle(lst,lst),lst#0),1))
seqPairList = n -> circularPairList (toList (0..(n-1)))

quicksort =


circularSortRays = rayList -> (
    pairedList := apply(rayList,pt-> (atan2(pt#1,pt#0),pt));
    --print sort(pairedList);
    (unzip(sort(pairedList)))#1)


toricFromRays = rayList -> (
    sortedRays := circularSortRays rayList;
    nrays := length(sortedRays);
    maxCones := seqPairList(nrays);
    normalToricVariety(sortedRays,maxCones))

randomRays = (h,p) -> (
    allPoints := toList({-h,-h}..{h,h});
    goodPoints := select(allPoints,(pt -> gcd(pt#0,pt#1)==1));
    select(goodPoints,(pt->(random(1.0)<p))))


rayListIsComplete = lst -> (
    if #lst==0 
    then false
    else (
        sortedRays := circularSortRays lst;
        cones := apply(circularPairList sortedRays,matrix);
        --for c in cones do if det c <= 0 then print c;
        --print apply(cones,x -> det x);
        all(cones,x -> det x > 0)))

--h is the maximum height, p is the probability
--may not actually return a toric surface, depending on whether the randomly chosen surface is actually valid
randomToricSurface = (h,p) -> (
    chosenRays := randomRays(h,p);
    if rayListIsComplete chosenRays
    then toricFromRays(chosenRays)
    else null)

measureSingularities = var -> (
    c := max var;
    r := rays var;
    apply(c,rayIds -> abs det matrix apply(rayIds,rId -> r#rId)))

--returns 0 for an empty list    
mean = lst -> if #lst==0 then 0 else sum(lst)/#lst
    
meanSingularity = var -> (
    sing := measureSingularities var;
    toRR mean sing)
    
