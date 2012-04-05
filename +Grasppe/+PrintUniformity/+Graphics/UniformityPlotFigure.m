classdef UniformityPlotFigure < Grasppe.Graphics.MultiPlotFigure
  %UNIFORMITYPLOTFIGURE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    PlotMediator
    DataSources
  end
  
  methods
    
    function obj = UniformityPlotFigure(varargin)
      obj = obj@Grasppe.Graphics.MultiPlotFigure(varargin{:});
    end
    
    function prepareMediator(obj)
      
      obj.PlotMediator  = Grasppe.Core.Mediator;
      
      dataProperties    = {'CaseID', 'SetID', 'SheetID'};
      axesProperties    = {'View', 'Projection', {'PlotColor', 'Color'}};
      
      obj.attachMediations(obj.PlotAxes, axesProperties);
      
      %       properties  = axesProperties;
      %       subjects    = plotAxes
      %       for m = 1:numel(subjects)
      %         subject = subjects{m};
      %         %if isa(subject, 'Grasppe.Graphics.PlotAxes')
      %           for n = 1:numel(properties)
      %             property = properties{n};
      %             if isa(property, 'char')
      %               alias     = property;
      %             elseif isa(property, 'cell')
      %               alias     = property{1};
      %               property  = property{2};
      %             else
      %               continue;
      %             end
      %             plotMediator.attachMediatorProperty(subject, property, alias);
      %           end
      %         %end
      %       end
      
    end
    
    function attachMediations(obj, subjects, properties)
      
      plotMediator  = obj.PlotMediator;
      
      for m = 1:numel(subjects)
        subject = subjects{m};
        for n = 1:numel(properties)
          property = properties{n};
          if isa(property, 'char')
            alias     = property;
          elseif isa(property, 'cell')
            alias     = property{1};
            property  = property{2};
          else
            continue;
          end
          plotMediator.attachMediatorProperty(subject, property, alias);
        end
      end
      
      obj.PlotMediator = plotMediator;
    end
  end
  
end
