function [w1,w2] = neuralnet(times)
 #   options = optimset('GradObj', 'on', 'MaxIter', '200');
    inputMatrix = csvread("writen.csv");
    sizeArr = size(inputMatrix);
        h = sizeArr(1);
    w = sizeArr(2);
    size(inputMatrix);
      errors = ones(times,h);

  #define hyper variables 
  inputLayerSize = w-1;
  outputLayerSize = 1;
  hiddenLayerSize = 5;
  eta = .5;
  lambda = 100; %any large value
 
 #set values of w1  
  w1 = rand(inputLayerSize,hiddenLayerSize);
  #setvalues of w2
  w2 = rand(hiddenLayerSize, outputLayerSize);
  #TODO: scale the input vector  
  
  for  i = 1:times 
   for m = 1:h

    #forward prop
     inputVector = inputMatrix(m,[1:(w-1)]);
     y = inputMatrix(m,w);
     
     z1 = inputVector * w1; 
     a1 = sigmoid(z1);

     a2 = a1 * w2;
     yhat = a2;
    #back prop
      d3 = yhat - y;
      
      errors(i,m) = d3;
      d2 = (w2')*d3 .* (a2.*(1.-a2));
    #regularize
     % d3 = d3 + lambda*w2;
     % d2 = d2 + lambda*w1;
    #weight update
      w1 = w1 - eta.*(d2*a1');
      w2 = w2 - eta.*(d3*a2');
      
    endfor;
    
    endfor;
    testnet(w1,w2,errors);
       
    #initialTheta = rand(5,5);
    #[optTheta, functionalVal, exitFlag] = fminunc(@primarycall, initialTheta, options)
    #out = optTheta
endfunction;

function [j,dJdW1,dJdW2]  = primarycall(theta)

  #get the dimension array of inputmatrix
  sizeArr = size(inputMatrix);
  h = sizeArr(1);
  w = sizeArr(2);
  

  
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

    j = costFunction(y,yhat,h);
    [dJdW1,dJdW2] = costFunctionPrime(y,yhat,z3,a2,z2,w2,X) ;

    
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

function J = costFunction(y,yhat,h)
  %J = sum(.5*(y-yhat).^2);
  J = sum(sum(y.*log(yhat) + (1.-y).*log(1.-yhat)))/(-h);
endfunction; 

function [dJdW1,dJdW2] = costFunctionPrime(y,yhat,z3,a2,z2,w2,X)

  delta3 = (-(y-yhat)) .* sigmoidPrime(z3);
  dJdW2 = a2'*delta3;
  
  delta2 = (delta3*w2').*sigmoidPrime(z2);
  dJdW1 = X'*delta2;
  
endfunction;

