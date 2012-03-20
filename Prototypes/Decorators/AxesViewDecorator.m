classdef AxesViewDecorator < GrasppePrototype & GrasppeDecorator
  %AXESVIEWDECORATOR Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    DecoratingProperties = {'View'};
  end
  
  properties (SetObservable, GetObservable)
    View
  end
  
  methods
    function obj = AxesViewDecorator(varargin)
      obj = obj@GrasppePrototype;
      obj@GrasppeDecorator(varargin{:});
    end
    
    %     function value = getView(obj)
    %     end
    %     function setView(obj, value)
    %       beep;
    %     end
    
    function set.View(obj, value)
      obj.View = value;
      if obj.Component.HasParentFigure
        try obj.Component.ParentFigure.StatusText.Text = toString(value); end
      end
    end
  end
  
  methods(Static, Hidden)
    function options  = DefaultOptions()
      options = [];
    end
  end
  
  
end
