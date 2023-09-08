#Let's create 2 signals, first is random noise
#second is random noise plus a very small deterministic signal
N = 10000;
x = rand(1,N); #first signal
t = (1:N)/16000;
A = 0.005; #You can control the amplitude of the deterministic signal
y = rand(1,N) + transpose(A*cos.(2*pi*100*t)); #second signal
#let's normalize the second signal
y = y .- minimum(y);
y = y ./ maximum(y);

#quantize the signal with saturation (to compute histogram)
#If we don't quantize it, there will be too many bins which
#might cause some issues
Nq=256;
q=1/Nq;
x = (floor.(x/q)).*q;
x[x .< 0] .= 0;
x[x .> 1-q] .= 1-q;
y = (floor.(y/q)).*q;
y[y .< 0] .= 0;
y[y .> 1-q] .= 1-q;

#compute histogram and get probabilities
#this could be done in a smarter way but
#we only have 2 signals
hist1=zeros(1,Nq);
hist2=zeros(1,Nq);
for i in 1:N
  index1=Int(x[i]/q)+1;
  index2=Int(y[i]/q)+1;
  hist1[index1]=hist1[index1]+1;
  hist2[index2]=hist2[index2]+1;
end
p1 = hist1 ./ N;
p2 = hist2 ./ N;

#compute entropy
E1 = sum(.- p1 .* log2.(p1));
E2 = sum(.- p2 .* log2.(p2));

println(E1)
println(E2)

if E1 > E2
  println("The entropy is higher for pure noise")
end
println("done")