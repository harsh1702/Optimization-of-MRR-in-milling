nn = 52;
dofn = 2;
ne = 52;
dofe = 4;
tdof = nn * dofn;

nconn = zeros(ne,2);
for i = 1:nn
    nconn(i,:) = [i,i+1];
end
nconn(52,2) = 1;

conn = zeros(ne,dofe);

for i = 1:ne
    for j = 1:2
        temp = nconn(i,j);
        ll = 2 * temp - 1;
        ul = 2 * temp;
        conn(i,2*j - 1:2*j) = ll:ul;
    end
end

u = 16/3 * 10^-3;
H = 3*10^-2;
t3 = 10.125*10^-9;
E = 70 * 10^9;
nu = 0.33;
rho = 2710;

KG = zeros(tdof,tdof);
MG = zeros(tdof,tdof);

Ke = zeros(4,4,ne);
Me = zeros(4,4,ne);

for i = 1:ne
    Ke(:,:,i) = t3 * H * E / (1-nu^2) .* [12/u^3, 6/u^2, -12/u^3, 6/u^2; 6/u^2, 4/u, -6/u^2, 2/u; -12/u^3, -6/u^2, 12/u^3, -30/u^2;6/u^2, 2/u, -30/u^2, 4/u ];
    Me(:,:,i) = rho * H * 4.5 * 10^-3 .* [(13/35)*u (11/210)*u^2 (9/70)*u (-13/420)*u^2;(11/210)*u^2 (1/105)*u^3 (13/420)*u^2 (-3/420)*u^3; (9/70)*u (13/420)*u^2 (13/35)*u (-11/210)*u^2; (-13/420)*u^2 (-3/420)*u^3 (-11/210)*u^2 (1/105)*u^3 ];
    for j = 1:dofe
        for k = 1:dofe
            KG(conn(i,j),conn(i,k)) = KG(conn(i,j),conn(i,k)) + Ke(j,k,i); 
            MG(conn(i,j),conn(i,k)) = MG(conn(i,j),conn(i,k)) + Me(j,k,i); 
        end
    end
end

cp = [2 10 18 26 8 16 24 32];     %Constraints

KGsimp = KG;
MGsimp = MG;
for j = cp
    KGsimp(:,j) = zeros(tdof,1);
    KGsimp(j,:) = zeros(1,tdof);
    KGsimp(j,j) = 1;
    MGsimp(:,j) = zeros(tdof,1);
    MGsimp(j,:) = zeros(1,tdof);
    MGsimp(j,j) = 1;

end