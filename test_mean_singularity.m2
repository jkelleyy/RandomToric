load "rand_toric_surf.m2"

--sequence of number starting at a, with step s less than or equal to b
seq := (a,s,b) -> (x:=a;while x<=b list x do x=x+s)

--a version that doesn't actually create the variety
randomCompleteRays := (h,p) -> (
    rayList := randomRays(h,p);
    sortedRays := circularSortRays rayList;
    if rayListIsComplete sortedRays
    then sortedRays
    else null)
     
--a version of mean singularities that uses a list     
raysMeanSingularity := rayList -> (
    coneList := circularPairList rayList;
    singList := apply(coneList, abs @@ det @@ matrix);
    toRR mean singList
    )

--Now the part that runs as a script
if #scriptCommandLine>0
then (if #scriptCommandLine<5
    then print "Too few arguments"
    else (
        maxH := value(scriptCommandLine#1);
        hstep := value(scriptCommandLine#2);
        pstep := value(scriptCommandLine#3);
        count := value(scriptCommandLine#4);
        for h in seq(10,hstep,maxH) do (
            for p in seq(pstep,pstep,1.0) do (
                << (h,p) << " : " << (mean (for i from 1 to count list (
                            surf := randomCompleteRays(h,p);
                            if surf===null then continue else raysMeanSingularity surf))) << endl << flush))
        ))