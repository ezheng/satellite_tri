function setMultiThreadContext(isUseMultipleCore, numWorkers)

poolobj = gcp('nocreate'); % If no pool, do not create new one.

% if numWorers does not change, and the pool exist, do nothing
if (~isempty(poolobj)) && (poolobj.NumWorkers == numWorkers) && isUseMultipleCore
    return;
end

% if the pool exist, delete it
if(~isempty(poolobj))
    delete(poolobj);   
end

% if I need to use multiple cores, then create one. Otherwise just use one
% core
if(isUseMultipleCore)
    my_cluster = parcluster('local');
    my_cluster.NumWorkers = numWorkers;
    saveProfile(my_cluster);
    parpool(numWorkers);
%   init_matlabpool(numWorkers);
end

end



% function [] = init_matlabpool(num_threads)
%     % by Jared Heinly
%     if matlabpool('size') ~= num_threads
%         my_cluster = parcluster('local');
%         my_cluster.NumWorkers = num_threads;
%         saveProfile(my_cluster);
% 
%         if matlabpool('size') > 0
%             matlabpool close
%         end
%         matlabpool('open', num_threads);
%     end
%     
% end % function