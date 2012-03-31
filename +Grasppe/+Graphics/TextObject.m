classdef TextObject < Grasppe.Graphics.AnnotationComponent
  %TEXT Summary of this class goes here
  %   Detailed explanation goes here
  
  properties (Transient, Hidden)
    ComponentType = 'text';
    
    TextHandleProperties = { ...
      {'Text', 'String'}, 'Color'};
    
  end
  
  properties (SetObservable, GetObservable, AbortSet)
    Text, Color
  end
  
  methods
    function obj = TextObject(parentAxes, varargin)
      obj = obj@Grasppe.Graphics.AnnotationComponent(parentAxes, varargin{:});
    end    
  end
  
  methods (Access=protected)
    
    function createComponent(obj)
      obj.createComponent@Grasppe.Graphics.InAxesComponent;
      
       %@(s,e)OnResize(obj, s, e));
    end
    
    function createHandleObject(obj)
      obj.Handle = text(0.5, 0.5, 0, obj.Text, 'Parent', obj.ParentAxes.Handle);
    end
    
    function decorateComponent(obj)
      Grasppe.Graphics.Decorators.FontDecorator(obj);
    end
       
  end
  
  
end

