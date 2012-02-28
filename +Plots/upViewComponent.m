classdef upViewComponent < Plots.upGrasppeHandle & ...
    Plots.upStyledObject & Plots.upEventHandler & Plots.upInstanceComponent
  %UPPLOTVIEW Summary of this class goes here
  %   Detailed explanation goes here
  
  properties (SetAccess = protected, GetAccess = protected)
    UpdatingView = false;     % To prevent Recursive-Updating
    UpdatingDelayTimer        % To delays Recursive-Updating
  end
  
  properties (SetAccess = public, GetAccess = public)
    Name
    Visible
    Tag
    HitTest
  end
  
  methods
    
    
    function obj = upViewComponent(varargin)
      
      if isValid('obj.Defaults','struct')
        obj.setOptions(obj.Defaults, varargin{:});
      else
        obj.setOptions(varargin{:});
      end
      
      if strcmpi(obj.Visible,'on')
        obj.createComponent();
      end
    end
    
    function obj = createComponent(obj, type, options)
      if (obj.Busy || isValidHandle('obj.Primitive'))
        return;
      end
      
      if (~isValid('options','cell') || isempty(options))
        options = obj.getComponentOptions;
      end
      
      if (~isValid('type','char'))
        try
          type = obj.ComponentType;
        catch err
          error('Grasppe:Component:MissingType', ...
            'Attempt to create component without specifying type.');
        end
      end
      
      if isValidHandle('obj.Parent')
        parent = obj.Parent;
      else
        parent = [];
      end
      
      hObj = obj.findObjects(obj.ID, type);
      
      if isempty(hObj)
        obj.Primitive = obj.createHandleObject(type, obj.ID, parent, options{:});
      else
        obj.Primitive = hObj(1);
        if ~isempty(parent)
          set(obj.Primitive, 'Parent', parent);
        end
        set(obj.Primitive, options{:});
      end
      
      obj.updateView;
      
      if (strcmpi(obj.Visible,'on'))
        obj.show();
      end
      
      setUserData(hObj, obj );
      set(hObj,'HandleVisibility', 'callback');
    end
    
    function tag = componentTag(obj, tag)
      tag = [obj.ID '.' tag];
    end
    
    function tag = createTag(obj, type, tag, parent)
      
      if isValidHandle(parent)
        parentTag = get(parent,'tag');
      else
        parentTag = '';
      end
      
      if isempty(tag)
        if isempty(parentTag)
          idx = numel(findall(0,'type',type)) + 1;
          tag = [constructor '_' int2str(idx)];
        else
          idx = numel(findobj(parent,'type',type)) + 1;
          tag = [parent '.' constructor '_' int2str(idx)];
        end
        tag = upper(tag);
      else
        if isempty(parentTag)
          %         else
          %           tag = [parentTag '.' tag];
        end
      end
      
    end
    
    function hObj = createHandleObject (obj, type, tag, parent, varargin)
      
      if ~(isValid('obj','object') && isValid('type','char'))
        error('Grasppe:CreateHandleObject:InvalidParamters', ...
          'Attempting to create a handle object without a valid object or type.');
      end
      
      constructor = [];
      
      type = lower(type);
      
      args = {varargin{:}};
      
      switch lower(type)
        case 'figure'
          constructor = lower(type);
          args = {args{:}, 'Visible', 'off'};
        case {'axes', 'plot', 'patch', 'surface', 'surf', 'surfc'}
          constructor = lower(type);
          %           args = {'Parent', obj.Parent, args{:}};
        case {'text'}
          constructor = lower(type);
        otherwise
          error('Grasppe:CreateHandleObject:UnsupportedGraphicsObject', ...
            'Could not create a handle object of type ''%s''.', type);
      end
      
      if isValidHandle(parent)
        args      = {args{:}, 'Parent', parent};
        %
        %         parentTag = get(parent,'tag');
        %       else
        %         parentTag = '';
      end
      
      tag = obj.createTag(type, tag, parent);
      
      disp([constructor ':     ' toString(toString(args{:}))]);
      
      hObj = feval(constructor, args{:}, 'Tag', tag);
      
      if isempty(get(hObj,'tag'))
        %         disp(get(hObj));
      end
      
      hProperties = get(hObj);
      
      hHooks      = regexpi(fieldnames(hProperties),'^\w+Fcn$','match','noemptymatch');
      hHooks      = horzcat(hHooks{:});
      
      hCallbacks  = hHooks;
      
      for i = 1:numel(hHooks)
        hook  = hHooks{i};
        callback        = get(hObj, hook);
        hCallbacks{2,i} = obj.callbackFunction(hook, callback);
      end
      
      set(hObj, hCallbacks{:});
      
      return;
      
    end
    
    function 	obj = show(obj)
      try
        h = Plots.upViewComponent.showHandle(obj.Primitive);
        if (h==0)
          if isValid('obj.ComponentType', 'char')
            obj.createComponent(obj.ComponentType);
          end
        end
      end
    end
    
    function obj = set.Visible(obj, value)
      obj.Visible = value;
      if (~obj.Busy && isValidHandle(obj.Primitive))
        %       try
        set(obj.Primitive, 'Visible',value);
        %       end
      end
    end
    
    function oldstate = markBusy(obj)
      oldstate = obj.Busy;
      obj.Busy = true;
    end
    
    function obj = updateComponent(obj)
      %       busy = obj.markBusy();
      %       try
      if ~isempty(obj.getComponentOptions) && isValidHandle(obj.Primitive)
        set(obj.Primitive, obj.getComponentOptions{:});
      else
        disp(obj.ID);
      end
      %       catch err
      %         warning(err.identifier, err.message);
      %       end
      %       obj.Busy = busy;
      
      %       drawnow();
      if (~obj.UpdatingView)
        updateView(obj);
      end
    end
    
    function obj = updateView(obj)
      
      if isequal(obj.Busy || obj.UpdatingView, true)
        delayTimer = obj.UpdatingDelayTimer;
        if ~isVerified('class(delayTimer)','timer');
        end
        try
          stop(delayTimer);
          start(delayTimer);
        end
        return;
      end
      
      obj.UpdatingView = true;
      obj.updateComponent;
      obj.UpdatingView = false;
      
    end
    
    
    %% Shared Property Wrappers
    
    function obj = resizeComponent(obj)
      
    end
    
    function obj = hide(obj)
      try
%         obj.Visible = 'off;'
      set(obj.Primitive,'Visible','off');
      obj.setOptions('Visible','off');
      end
    end
    
    function obj = finalizeComponent(obj)
      delete(obj.Primitive);
    end
    
    function obj = closeComponent(obj)
      d = dbstack;
      isClose = any(strcmpi({d.('file')}, 'close.p'));
      
      try
        hType = get(obj.Primitive,'type');
        
        switch lower(hType)
          case 'figure'
            if (isClose || isQuitting())
              obj.finalizeComponent();
            else
              obj.hide();
              try
                disp(sprintf(['\n%s is closed but the figure is not deleted.\n\nYou can still '...
                  '<a href="matlab: %s.showHandle(%d);">reopen</a> it or ' ...
                  '<a href="matlab: delete(%d);">delete</a> it to '...
                  'reclaim resources.\n\n'], obj.Name, eval(CLASS), obj.Primitive, obj.Primitive));
%                 grasppeQueue([], ['Reopen ' obj.Name], ['click the link to reopen this figure'], ...
%                   sprintf('%s.showHandle(%d);', eval(CLASS), obj.Primitive));
%                 grasppeQueue([], ['Delete ' obj.Name], ['click the link to delete the figure'], ...
%                   sprintf('delete(%d);', obj.Primitive));
              end
            end
          otherwise
            obj.finalizeComponent();
            return;
        end
      end
    end
    
    function delete(obj)
      try
        delete(obj.Primitive);
      end
    end
    
  end
  
  %% Options & Preferences
  
  %% Callbacks
  methods (Static)
    function delayTimer = getDelayTimer(object, tag)
      
      TimerFunction = object.callbackFunction('UpdateView');
      TimerOpt      = {'ExecutionMode', 'singleShot', 'StartDelay', 1, 'Name','DelayTimer'};
      delayTimer = timer('TimerFcn', TimerFunction, TimerOpt{:});
      object.UpdatingDelayTimer = delayTimer;
      
    end
    
    function 	handle = showHandle(handle)
      try
        set(handle,'Visible', 'on');
        switch lower(get(handle,'type'))
          case 'figure'
            figure(handle)
          case 'axes'
            axes(handle);
        end
      catch err
        handle = 0;
      end
    end
    
  end
  
  methods(Abstract, Static)
    options  = DefaultOptions()
  end
  
end

