function [ output_args ] = testBuffering( input_args )
  %TESTBUFFERING Summary of this function goes here
  %   Detailed explanation goes here
  warnState = warning ('off', 'backtrace');
  Data.dataSources([], 'verbose', true, 'sizeLimit', 200);
  rt = tic;
  
  for source = {'rithp7k01','rithp5501','ritsm7402a','ritsm7402b','ritsm7402c'};
    for set = [-1 0 25 50 75 100]
      
      t = tic;
      [stats parser params] = Plots.supStats(char(source),set);
      et = toc(t);
      %       params = parser.Results;
      src = params.dataSourceName;
      rsrc = [src blanks(10-numel(src))];
      tv = params.dataPatchSet;
      dsrc = Data.dataSources;
      names = dsrc.names;
      rnames = strrep(names,'rit','');
      rnames = strrep(rnames,'sm','');
      rnames = strrep(rnames,'hp','');
      elements = dsrc.elements;
      bytes = dsrc.bytes;
      fprintf([ '%s' '\t' '% 4.0f' '\t' '%5.2f' '\t' '%2.0f' '\t' '% 7.2f' '' '\t' '%s' '\n'],rsrc, tv, et, elements, bytes/(2^20), rnames);
      
      
    end
  end
  toc(rt);
  Data.dataSources([], 'verbose', 'reset', 'sizeLimit', 'reset');
  warning(warnState);
  
end

