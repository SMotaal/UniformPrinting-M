classdef Prototype < handle & dynamicprops %& hgsetget
  %GRASPPEPROTOTYPE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    MetaProperties
    ClassName
    ClassPath
    MetaClass
  end
  
  methods
    function obj = GrasppePrototype()
      GrasppePrototype.InitializeGrasppePrototypes;
      
      obj.createMetaPropertyTable;
    end
    
%    function processMetaData(obj)
%        try
% -        if iscell(obj.MetaProperties) && size(obj.MetaProperties, 2)==5
% +        definedProperties = obj.MetaProperties;
% +        if iscell(definedProperties) && size(definedProperties, 2)==5
%            metaProperties   = struct;
% -          for i = 1:size(obj.MetaProperties, 1)
% -            property    = obj.MetaProperties{i,1};
% -            metaData    = obj.MetaProperties(i,2:end);
% +          for i = 1:size(definedProperties, 1)
% +            property    = definedProperties{i,1};
% +            metaData    = definedProperties(i,2:end);
%              
%              metaProperties.(property) = GrasppeMetaProperty.Declare( ...
%                property, class(obj), metaData{:});
% @@ -25,9 +31,37 @@ classdef GrasppePrototype < handle
%            obj.MetaProperties = metaProperties;
%          end
%        catch err
% -%         disp(err);
% +        % disp(err);
%        end
%      end
    
    
    function createMetaPropertyTable(obj)
      if isempty(obj.MetaProperties)
        definedProperties = obj.getRecursiveProperty('Properties');
        definedProperties = vertcat(definedProperties{:});
        tableSize = size(definedProperties);
        
        if isa(definedProperties, 'cell') && tableSize(2)==5
          metaProperties   = struct;

          for m = 1:tableSize(1)
            property    = definedProperties{m,1};
            metaData    = definedProperties(m,2:5);
            
            metaProperties.(property) = GrasppeMetaProperty.Declare( ...
              property, class(obj), metaData{:});
          end
          obj.MetaProperties = metaProperties;
%         else
%           obj.MetaProperties = NaN;
        end
      end      
    end
    
    function dup = CreateDuplicate(obj)
      dup = [];
    end
    
    
    function className = get.ClassName(obj)
      % superName = eval(CLASS);
      className = class(obj);
      % if (strcmpi(superName, className))
      %   warning('Grasppe:Component:ClassName:Unexpected', ...
      %     ['Attempting to access a component''s super class (%s) instead of the ' ...
      %     'actual component. Make sure this is the intended behaviour.'], superName);
      % end
    end
    
    function classPath = get.ClassPath(obj)
      classPath = fullfile(which(obj.ClassName));
    end
    
    function metaClass = get.MetaClass(obj)
      metaClass = metaclass(obj);
    end    
      
    function propertyTable = getRecursiveProperty(obj, suffix)
        propertyTable = {};
        try
          tree = vertcat(class(obj), superclasses(obj));

          for m = 1:numel(tree)
            prefix = tree{m};
                        
            try
              classProperties       = obj.([prefix suffix]);
              propertyTable{end+1}  = classProperties;
%               if isempty(propertyTable)
%                 propertyTable = classProperties;
%               else
%                 propertyTable = vertcat(propertyTable, classProperties);
%               end
            end
              
          end
        end      
    end
    
    
  end
  
  methods (Static, Hidden)
  
%     function propertyTable = getRecursiveProperty(className, suffix)
%         propertyTable = {};
%         try
%           tree = vertcat(className, superclasses(className));
% 
%           for m = 1:numel(tree)
%             prefix = tree{m};
%                         
%             try
%               classProperties = obj.([prefix suffix]);
%               if isempty(propertyTable)
%                 propertyTable = classProperties;
%               else
%                 propertyTable = vertcat(propertyTable, classProperties);
%               end
%             end
%               
%           end
%         end      
%     end
  
    function InitializeGrasppePrototypes(forced)
      persistent initialized;
      try  if forced, initialized = false; end, end
      
      if ~isequal(initialized, true)
        [currentPath] = fileparts(mfilename('fullpath'));
        
        folders     = dir(currentPath);
        folderNames = {folders([folders.isdir]).name};
        subNames    = folderNames(~cellfun('isempty', ...
          regexp(folderNames,'^[A-Z].*')));
        
        subPaths    = strcat(currentPath,filesep,subNames);
        
        addpath(subPaths{:});
        initialized = true;
      end
    end
    
    function checks = checkInheritence(obj, classname)     
      checks = false;
      try
        checks = isa(obj, classname);
      catch
        try checks = isa(obj, eval(CLASS)); end
      end
    end
    
  end
  
end
