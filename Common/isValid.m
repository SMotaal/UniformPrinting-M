function [ result exception ] = isValid( object, expectedClass, varargin )
  %ISVALID Validate class and check size
  %   Detailed explanation goes here
  
  parser = inputParser;
  
  %% Parameters
  parser.addRequired('object'); %, @(x) ischar(x) | isobject(x));
  
  parser.addRequired('expectedClass', @ischar);
  
  parser.addOptional('expectedSize', [1 1], ...
    @(x) isnumeric(x) && ...
    ( (size(x,1)==1 && ndims(x)==2) || (numel(x)==1)  ) );
  
  parser.parse(object, expectedClass, varargin{:});
  
  params = parser.Results;
  
  result    = false;
  exception = [];
  
  object          = params.object;
  expectedClass   = params.expectedClass;
  expectedSize    = params.expectedSize;
  
  if (ischar(object) && isempty(inputname(1))) %~isempty(regexp(object,'^=[^=]*$'))
    try
      object = evalin('caller', object);
    catch err
      exception = MException('Grasppe:IsValid:InvalidObject', 'Evaluation of object in caller failed.');
      return;
    end
  end
  
  %% Validation
  validClass = isClass(object, expectedClass);
  
  if numel(expectedSize) == 1
    validSize = numel(object) == expectedSize;
  else
    validSize = all(size(object) == expectedSize) && ...
      all(size(size(object)) == size(expectedSize));
  end
  
  result = validClass && (validSize || (ischar(object)&&~isempty(object)));
  
end

