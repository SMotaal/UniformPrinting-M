function [ data ] = InterpData( forced )
  %INTERPDATA Summary of this function goes here
  %   Detailed explanation goes here
  
  default forced false;
   
  if forced
    PersistentSources('clear');
  end
  
  PersistentSources('readonly');
  
  data = struct;
  
  for source = {'ritsm7402a', 'ritsm7402b', 'ritsm7402c', 'rithp7k01', 'rithp5501'}
    data.(char(source)) = Alpha.supInterp(char(source), forced, false);
  end
  
  if forced
    PersistentSources('readonly save');
  end
  
end
