
function output_metrics_excel3(basedirectory,structure,plannumber,maxnum_metrics,metric,xlnum,plans,st_structure_metrics)
% function to output an array into an excel spreadsheet based on the name
% of the structure (excel sheet) and name of plan ( excel row and column
% number)

 filename=sprintf('%s\\metricresults',basedirectory);
 sheet=structure;
 %the range will be determined by a number related to the plan details and
 %a letter related to the order of the parameters (probably defined by
 %the variable arguements order so this order will need to match output
 %order

     letter='B';

         
 range=sprintf('%s%d',letter,plannumber+xlnum);
 range2=sprintf('%s%d','A',plannumber+xlnum);
% for i=1:maxnum_metrics
xlswrite(filename, plans, sheet, range2);
xlswrite(filename, st_structure_metrics', sheet, 'A1');
xlswrite(filename, metric, sheet, range);

% end
 end

                     