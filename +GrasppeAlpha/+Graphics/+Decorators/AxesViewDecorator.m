classdef AxesViewDecorator < GrasppeAlpha.Core.Prototype & GrasppeAlpha.Core.PropertyDecorator
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
      obj = obj@GrasppeAlpha.Core.Prototype;
      obj = obj@GrasppeAlpha.Core.PropertyDecorator(varargin{:});
    end
    
    %     function value = getView(obj)
    %     end
    %     function setView(obj, value)
    %       beep;
    %     end
    
    function set.View(obj, value)
      locked = false;
      try locked = isequal(obj.Component.ViewLock, true); end
      
      if ~locked 
        obj.View = value; 
      else
        obj.Component.View = obj.View;
      end
%       if obj.Component.HasParentFigure
%         try obj.Component.ParentFigure.StatusText.Text = toString(value); end
%       end
    end
  end
  
  methods(Static, Hidden)
    function OPTIONS  = DefaultOptions()
      GrasppeAlpha.Utilities.DeclareOptions;
    end
  end
  
  
end

