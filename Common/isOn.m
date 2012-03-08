function [ state ] = isOn( state, onState, offState )
  %ISON Logical state check
  %   Detailed explanation goes here
  
%   default onState true;
%   default offState false;
% 
%   if ischar(state)
%     state = lower(state);
%   end
  
  switch lower(state)
  case {1, true, 'yes', 'on'};
    state = true;
    if exist('onState', 'var')
      state = onState;  
    end
    otherwise % case {0, false, 'no'};
    state = offState;
    state = false;
    if exist('offState', 'var')
      state = offState;  
    end    
  end

end
