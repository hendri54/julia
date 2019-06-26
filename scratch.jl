# Scratch space for testing code in Juno

n = 4;
prefScale = 0.4;
dbg = true;


nTypes = 1

value_xV = collect(range(100.0, 110.0, length = n)');

if nTypes == 1
   value_ixM = value_xV;
else
   value_ixM = collect(range(1.0, 0.9, length = nTypes)) *
     collect(range(100.0, 110.0, length = n)');
end

prob_ixM, eVal_iV = econLH.extreme_value_decision(value_ixM, prefScale, dbg);
check_by_sim(value_ixM, prob_ixM, eVal_iV, prefScale);

typeof(eVal_iV)
