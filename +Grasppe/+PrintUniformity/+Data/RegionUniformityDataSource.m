classdef RegionUniformityDataSource < Grasppe.PrintUniformity.Data.UniformityDataSource
  %SURFACEUNIFORMITYDATASOURCE Raw printing uniformity data source
  %   Detailed explanation goes here
  
  properties
    % RawUniformityDataSourceProperties = {
    %   'TestProperty', 'Test Property', 'Labels', 'string', '';   ...
    %   };
    % TestProperty
  end
  
  methods (Hidden)
    function obj = RegionUniformityDataSource(varargin)
      obj = obj@Grasppe.PrintUniformity.Data.UniformityDataSource(varargin{:});
    end

    function [X Y Z] = processSheetData(obj, sheetID, variableID)

      [X Y Z]   = obj.processSheetData@Grasppe.PrintUniformity.Data.UniformityDataSource(sheetID, variableID);
      
      sourceData      = obj.SourceData;
      setData         = obj.SetData;
      
      sheetData       = squeeze(setData.surfs.(variableID).Mean(sheetID, 1, :, :));
      
      targetFilter    = sourceData.sampling.masks.Target~=1;
      
      Z(:)            = sheetData;
      Z(targetFilter) = NaN;
      
%       dataFilter  = ~isnan(Z);
%       
%       F = TriScatteredInterp(X(dataFilter), Y(dataFilter), Z(dataFilter));
%       
%       Z = F(X, Y);
%       Z(targetFilter) = NaN;

      
      % Z = Grasppe.PrintUniformity.Data.LocalVariabilityDataSource.localVariabilityFilter(Z);
      
      %Z(patchFilter~=1)   = NaN;      
      
    end
    
    function optimizeSetLimits(obj)
      % zLim    = [0 10];
      
      obj.ZLim  = 'auto';
      obj.CLim  = 'auto';
    end
    
    
  end
  
  methods (Static, Hidden)
%     function newData = rawUniformityFilter(zData)
%       newData = zData;
%       end
%     end

    function OPTIONS  = DefaultOptions()      
      Grasppe.Utilities.DeclareOptions;
    end
  end
  
  methods (Static)
    function obj = Create(varargin)
      obj = Grasppe.PrintUniformity.Data.RawUniformityDataSource(varargin{:});
    end
  end
  
  
end
