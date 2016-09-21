
function yhat  = primarycall(theta)

  inputMatrix = csvread("AAPLwithWeather.csv");
  #get the dimension array of inputmatrix
  sizeArr = size(inputMatrix);
  h = sizeArr(1);
  w = sizeArr(2);
  
  #define hyper variables 
  inputLayerSize = w-1;
  outputLayerSize = 1;
  hiddenLayerSize = w-1;
  
  # based on the sizes make X the 1:(w-1)cols, so remove just w
  X = inputMatrix(:,[1:(w-1)]);
  #make y the w col. so just remove (w-1)
  y = inputMatrix(:,[w]);
  
  #scale both matricies
  #getmax for post scaling the out put
  maxOfy = max(y);
  X = scale(X);
  y = scale(y);
  
  #set values of w1  
  w1 = rand(inputLayerSize,hiddenLayerSize);
  
  #setvalues of w2
  w2 = rand(hiddenLayerSize, outputLayerSize);


  #forward propogation
    #put everything through weights
    z2 = X * w1;

    #pass through activation function
    a2 = sigmoid(z2);

    #pass through second layer of weights
    z3 = a2*w2; 
   
    #pass through activation function second time
    yhat = sigmoid(z3);
    yhat = yhat.*maxOfy;
    ids = linspace(1,h,h);
    y = y.*maxOfy;
    plot(ids,yhat,"r",ids,y,"b");
    
endfunction;

function scaled = scale(inMatrix)
#scale a matrix in this case by looking at maximum val and dividing
  scaled = inMatrix./max(inMatrix);
endfunction;

function y = sigmoid(z)
  y = 1 ./ (1 + e.^-z);
endfunction;

function y = sigmoidPrime(z)
  y = (e.^-z)./((1+e.^-z).^2);
endfunction;

function J = costFunction(y,yhat)
  J = sum(.5*(y-yhat).^2);
endfunction; 

function [dJdW1,dJdW2] = costFunctionPrime(y,yhat,z3,a2,z2,w2,X)

  delta3 = (-(y-yhat)) .* sigmoidPrime(z3);
  dJdW2 = a2'*delta3;
  
  delta2 = (delta3*w2').*sigmoidPrime(z2);
  dJdW1 = X'*delta2;
  
endfunction;

