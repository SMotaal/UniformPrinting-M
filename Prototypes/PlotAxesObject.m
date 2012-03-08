classdef PlotAxesObject < AxesObject
  %PLOTAXESOBJECT Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    
  end
  
  methods (Access=protected, Hidden)
    function obj = PlotAxesObject(parentFigure, varargin)
      obj = obj@AxesObject(varargin{:},'ParentFigure', parentFigure );
    end
    
    function createComponent(obj, type)
      obj.createComponent@GrasppeComponent(type);
      
      obj.OuterPosition = [0.1 0.1 0.8 0.8];
    end
    
  end
  
  methods (Hidden)
    function obj = resizeComponent(obj)
      parentPosition  = pixelPosition(obj.ParentFigure.Handle);
      
      padding=obj.Padding;
      
      size     = parentPosition([3 4]) - padding([1 2]) - padding([3 4]);
      position = [padding([1 2]) size];
      
      obj.set('Units', 'pixels', 'outerposition', position);
    end    
  end
  
  methods (Static, Hidden)
    function options  = DefaultOptions( )
      
      IsVisible     = true;
      IsClickable   = true;
      Box           = 'on';
      Color         = 'none';
      
      options = WorkspaceVariables(true);
    end
    
  end
  
  methods (Static)
    function obj = createAxesObject(parentFigure, varargin)
      obj = PlotAxesObject(parentFigure, varargin{:});
    end    
  end
  
  
end
