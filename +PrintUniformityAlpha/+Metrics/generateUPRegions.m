function [ dataSource regions ] = generateUPRegions( dataSource )
  %GENERATEUPREGIONS generate printing uniformity roi masks
  %   Detailed explanation goes here
  
  % dataSource.regions.across     (axial)
  % dataSource.regions.around     (circumferential)
  % dataSource.regions.sections   (proportionate print area subdivision)
  % x dataSource.regions.pages    (optimized letter-page imposition regions)
  % dataSource.regions.zones      (inkzone print area subdivision)
  % dataSource.regions.zoneBands  (circumferential inkzones subdivisions)
  
  
  [masks metrics] = regionROI(dataSource.metrics);
  try
    [masks metrics] = zoneROI(metrics, masks);
  end
  
  dataSource.metrics  = metrics;
  
  for fieldname = fieldnames(masks)'
    field = char(fieldname);
    dataSource.sampling.regions.(field)  = masks.(field);
  end
  
  if nargout==2
    regions = dataSource.sampling.regions;
  end
  
end


function [masks, metrics] = zoneROI(metrics, masks)
  zones       = metrics.sampleZones;
  rows        = metrics.sampleSize(1);
  columns     = metrics.sampleSize(2);
  pitch       = [metrics.patchLength metrics.patchWidth];  
  length      = metrics.sampleLength;
  
  lengthMetrics = Metrics.bandMetrics(length, 3, pitch(1));
  
  lengthBands = lengthMetrics.Bands;
  zoneBands  = numel(zones);
  
  zoneBandMasks = zeros(zoneBands * lengthBands, rows, columns);
  zoneMasks = zeros(zoneBands, rows, columns);
  
  metrics.zoneSteps   = ([reshape(zones',1,[]) zones(end)+1] - zones(1)) .* 4;
  
  for z = 1:zoneBands
    c1 = metrics.zoneSteps(z)+1;
    c2 = metrics.zoneSteps(z+1);
    
      zoneMasks(z, :, :) = rectMask(rows, columns, [], [], c1, c2);
    
      for l = 1:lengthBands
        r1 = lengthMetrics.Steps(l)+1;
        r2 = lengthMetrics.Steps(l+1);
        
        i = ((l-1)*zoneBands) + z;
        zoneBandMasks(i, :, :) = rectMask(rows, columns, r1, r2, c1, c2);
    
      end

  end
  
  zonesBandsAroundMasks = zeros(lengthBands, rows, columns);
  
  for l = 1:lengthBands
    r1 = lengthMetrics.Steps(l)+1;
    r2 = lengthMetrics.Steps(l+1);
    
    zonesBandsAroundMasks(l, :, :) = rectMask(rows, columns, r1, r2, [], []);
  end
  
  masks.zones           = zoneMasks;
  masks.zonesAround     = ones(1, rows, columns);
  masks.zonesAcross     = zoneMasks;
  
  masks.zoneBands       = zoneBandMasks;
  masks.zoneBandsAround = zonesBandsAroundMasks;
  masks.zoneBandsAcross = zoneMasks;
  
  return;
    
end

function [masks, metrics] = regionROI(metrics, masks)
  rows        = metrics.sampleSize(1);
  columns     = metrics.sampleSize(2);
  pitch       = [metrics.patchLength metrics.patchWidth];  
  sampleArea  = metrics.sampleArea;
  length      = metrics.sampleLength;
  width       = metrics.sampleWidth;
  
  %% Determine principle (shorter) dimension and index
  [minor, minorSide]  = min(sampleArea);
  [major,  majorSide] = max(sampleArea);  % longSide = setdiff([1 2], shortSide);
  
  minorBands    = 3;
  minorMetrics  = Metrics.bandMetrics(minor, minorBands, pitch(minorSide));
  
  majorBands    = firstOdd(major / minorMetrics.BandWidth);
  majorMetrics  = Metrics.bandMetrics(major, majorBands, pitch(majorSide));
  
  if (width>length)
    widthMetrics  = majorMetrics;
    lengthMetrics = minorMetrics;
  else
    widthMetrics  = minorMetrics;    
    lengthMetrics = majorMetrics;
  end  
  
  lengthBands = lengthMetrics.Bands;
  widthBands  = widthMetrics.Bands;
  
  metrics.orientation = (width>length);
  metrics.minorMetrics = minorMetrics;
  metrics.majorMetrics = majorMetrics;
  
  sectionMasks = zeros(minorBands * majorBands, rows, columns);
  lengthMasks = zeros(lengthBands, rows, columns);  
  widthMasks = zeros(widthBands, rows, columns);
 
  
  for l = 1:lengthBands
    r1 = lengthMetrics.Steps(l)+1;
    r2 = lengthMetrics.Steps(l+1);
    
    lengthMasks(l, :, :) = rectMask(rows, columns, r1, r2, [], []);
    
    for w = 1:widthBands
      c1 = widthMetrics.Steps(w)+1;
      c2 = widthMetrics.Steps(w+1);
      
      widthMasks(w, :, :) = rectMask(rows, columns, [], [], c1, c2);
      
      i = ((l-1)*widthBands) + w;
      sectionMasks(i, :, :) = rectMask(rows, columns, r1, r2, c1, c2);
    end
  end
  
  masks.sections        = sectionMasks;
  
  masks.across    = widthMasks;
  masks.around    = lengthMasks;
    
end

function [mask rect] = rectMask (rows, columns, startRow, endRow, startColumn, endColumn)
  mask = [];
  
  if (validCheck(rows,'double') && validCheck(columns,'double'))
    
    default startRow    1;
    default startColumn 1;
    default endRow      = rows;
    default endColumn   = columns;
    
    mask = zeros(rows, columns);
    
    try
      rect = [...
        startRow  startColumn; ...
        endRow    endColumn];
      
      mask(rect(1):rect(2), rect(3):rect(4)) = 1;
    catch err
      try debugStamp(err, 1); catch, debugStamp(); end;
    end
    
  end
  
end
