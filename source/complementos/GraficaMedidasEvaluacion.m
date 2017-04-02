

figure (2)
hold on
plot(cell2mat(medidasEvalANN(:,1)).*cell2mat(medidasEvalANN(:,2)))
plot(cell2mat(medidasEvalENN(:,1)).*cell2mat(medidasEvalENN(:,2)))
plot(cell2mat(medidasEvalANN(:,1)))
plot(cell2mat(medidasEvalENN(:,1)))
plot(cell2mat(medidasEvalANN(:,2)))
plot(cell2mat(medidasEvalENN(:,2)))
hold off


