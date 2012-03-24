classdef UniformitySurfaceObject < GrasppePrototype & SurfaceObject & UniformityPlotObject
  %UNIFORMITYSURFACEPLOT Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    ExtendedDataProperties = {};
  end
  
  properties (Dependent)
  end
  
  methods (Access=protected)
    function obj = UniformitySurfaceObject(parentAxes, varargin)
      obj = obj@GrasppePrototype;
      obj = obj@SurfaceObject(parentAxes, varargin{:});
      obj = obj@UniformityPlotObject();
    end
    function createComponent(obj, type)
      obj.createComponent@SurfaceObject(type);
      obj.createComponent@UniformityPlotObject(type);
      
      obj.ParentFigure.registerMouseEventHandler(obj);
      obj.handleSet('EdgeAlpha', 0.5);
    end
  end
  
  
  methods
    function refreshPlot(obj, dataSource)

      % if ~obj.HasParentAxes, return; end
      
      try obj.ParentAxes.ZLim = dataSource.ZLim; end
      try obj.ParentAxes.CLim = dataSource.CLim; end
      
    end
    
    function refreshPlotData(obj, source, event)
      try debugStamp(obj.ID); catch, debugStamp(); end;
      try
        dataSource  = event.AffectedObject;
        dataField   = source.Name;
        
        % disp(sprintf('Refreshing %s.%s', dataSource.ID, dataField));
        
        obj.handleSet(dataField, dataSource.(dataField));
      catch err
        try debugStamp(obj.ID); end
        disp(err);
      end
    end
    
    
    function consumed = mouseWheel(obj, source, event)
      consumed = true;
      
      if ~obj.HasParentFigure || ~obj.HasParentAxes || event.consumed
        consumed = event.consumed;  
        return;
      end
      
      % disp([hittest obj.Handle obj.ParentAxes.Handle]);
      
      if ~isequal(obj.Handle, hittest)
        consumed = false;
        return;
      end
      
%       currentObject   = obj.ID;
%       activeObject    = class(obj.ParentFigure.ActiveObject);
%       try activeObject  = obj.ParentFigure.ActiveObject.ID; end
%         
%       if ~isequal(currentObject, activeObject)
%         %disp(['Current object ' currentObject ' is not the Active object ' activeObject '.']);
%         consumed = false;
%         return;
%       else
%         %disp(['Current object ' currentObject ' is the Active object.']);
%       end
      
      if ~event.Scrolling.Momentum
        % disp(toString(event));
        % plotAxes = get(obj.handleGet('CurrentAxes'), 'UserData');
        if event.Scrolling.Vertical(1) > 0
          obj.setSheet('+1');
        elseif event.Scrolling.Vertical(1) < 0
          obj.setSheet('-1');
        end
      end
    end
    
  end
  
  methods (Static)
    function obj = Create(parentAxes, varargin)
      obj = UniformitySurfaceObject(parentAxes, varargin{:});
    end
  end
  
  
  methods (Static, Hidden)
    function options  = DefaultOptions( )
      
      IsVisible     = true;
      IsClickable   = true;
      
      options = WorkspaceVariables(true);
    end
    
  end
  
end

