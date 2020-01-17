load('PerfectArial');
aux = eye(10);
perfeitos=[];
targets=[];
for i=1:75
    targets = horzcat(targets,aux);
end

testes=[];
for i=1:5
    testes = horzcat(testes,targets);
end


for i=1:75
    perfeitos = horzcat(perfeitos,Perfect);
end

save('targets.mat','targets')
save('perfeitos.mat','perfeitos')
save('testes','testes')


