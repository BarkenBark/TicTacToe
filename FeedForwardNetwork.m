classdef FeedForwardNetwork < handle
  
  properties
    %Topology
    weights; %Cell vector of weight matrices
    thresholds; %Cell vector of threshold vectors
    networkDimensions;
    nbrOfLayers;
    
    %Mechanics
    layerFunction;
    layerFunctionDerivative; %For backpropagation
  end
  
  methods
    function obj = FeedForwardNetwork(networkDimensions)
      obj.networkDimensions = networkDimensions;
      obj.nbrOfLayers = length(networkDimensions);
      obj.weights = cell(1, obj.nbrOfLayers-1);
      obj.thresholds = cell(1, obj.nbrOfLayers-1);
      obj.layerFunction = cell(1, obj.nbrOfLayers-1);
      obj.layerFunctionDerivative = cell(1, obj.nbrOfLayers-1);
    end
        
    function SetWeights(obj, weights)
      obj.weights = weights;
    end
    
    function SetThresholds(obj, thresholds)
      obj.thresholds = thresholds;
    end
    
    %Accepts cell array of function handles, layerFunction{1} is arbitrary
    %Alternatively, accepts string layerFunction in {'tanh', 'sigmoid'}
    function SetActivationFunction(obj, layerFunction)
      if ischar(layerFunction)
        if strcmp(layerFunction, 'tanh')
          [obj.layerFunction{:}] = deal(@(s) tanh(s));
          [obj.layerFunctionDerivative{:}] = deal(@(s) 1-tanh(s).^2);
        elseif strcmp(layerFunction, 'sigmoid')
          [obj.layerFunction{:}] = deal(@(s) 1./(1+exp(-s)));
          [obj.layerFunctionDerivative{:}] = ...
            deal(@(s) obj.layerFunction(s).*(1-obj.layerFunction(s)));
        else
          disp(strcat(layerFunction, ' is not a predefined function.'));
        end
      elseif iscell(layerFunction)
        if isvector(layerFunction) && length(layerFunction) == obj.nbrOfLayers-1
          obj.layerFunction = layerFunction;
        else
          fprintf(strcat('Enter a cell array of function handles of ', ...
            'length %d.\n'), obj.nbrOfLayers-1);
        end
      else
        disp('Enter either a char or a cell array of function handles.');
      end
    end
    
    function RandomlyInitializeWeights(obj, weightInterval, thresholdInterval)
      for iLayer = 1:obj.nbrOfLayers-1
        weightDimension = [obj.networkDimensions(iLayer+1), ...
          obj.networkDimensions(iLayer)];
        thresholdDimension = [obj.networkDimensions(iLayer+1), 1];
        
        minWeight = weightInterval(1);
        maxWeight = weightInterval(2);
        tmp = rand(weightDimension);
        tmpWeights = minWeight + (maxWeight-minWeight).*tmp;
        
        minThreshold = thresholdInterval(1);
        maxThreshold = thresholdInterval(2);
        tmp = rand(thresholdDimension);
        tmpThresholds = minThreshold + (maxThreshold-minThreshold).*tmp;
        
        obj.weights{iLayer} = tmpWeights;
        obj.thresholds{iLayer} = tmpThresholds;
      end
    end
    
    function output = ForwardPropagate(obj, input)
      output = input;
      for iLayer = 1:obj.nbrOfLayers-1
        s = obj.weights{iLayer}*output - obj.thresholds{iLayer};
        output = obj.ActivationFunction(iLayer+1, s);
      end
    end
    
    %Compute activation function of layer iLayer evaluated in s
    function value = ActivationFunction(obj, iLayer, s)
      thisLayerFunction = obj.layerFunction{iLayer-1};
      value = thisLayerFunction(s);
    end
  end
  
end

