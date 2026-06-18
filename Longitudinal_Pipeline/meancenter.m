function [Y]=meancenter(X)

for i=1:size(X,2) %loop through columns
Y(:,i)=X(:,i)-mean(X(:,i));
end
