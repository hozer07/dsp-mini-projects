function [centroids,new_memberships] = fuzzy_k_means_clustering(input_objects,m)
    % First step of clustering
    membership = rand(size(input_objects,2),3); % Assigning random membership values to samples
    centroids =zeros(3,2);
    temp = input_objects';
    for i=1:size(input_objects,2)
        membership(i,:) = membership(i,:)./sum(membership(i,:)); % Normalizing initial memberships to have their sum equal to 1
    end
    if(m==1),membership = (membership==max(membership,[],2));end
    for i=1:3
        centroids(i,:) = sum(repmat(membership(:,i),1,2).*temp,1)./sum(membership(:,i)); % Calculating initial centroids for random memberships
    end
    centroids2 = centroids';
    voronoi_distances = (repmat(temp,1,3)-centroids2(:)').^2;
    voronoi_distances2 = zeros(150,3);
    for i=1:3
        voronoi_distances2(:,i) = (voronoi_distances(:,2*i-1)+voronoi_distances(:,2*i)); % Calculating distances for initial clusters
    end
    new_memberships = zeros(150,3);
    if(m>1)
        for i=1:150
            for j=1:3
                new_memberships(i,j) = sum(voronoi_distances2(i,j)./voronoi_distances2(i,:))^(1/(1-m)); % Calculating new membership values for calculated centroids
            end
        end
    else
       new_memberships = (voronoi_distances2==min(voronoi_distances2,[],2)); % Case for m=1, regular k-means clustering
    end
    err = sum(abs(membership-new_memberships),'all'); % Checking if clusters change
    membership = new_memberships;
    threshold = 1e-5;
    while(err>threshold)                               % Stopping criterion, repeat above steps until clusters remain constant
        for i=1:3
            centroids(i,:) = sum(repmat(membership(:,i),1,2).*temp,1)./sum(membership(:,i)); %Cluster Update
        end
        centroids2 = centroids';
        voronoi_distances = (repmat(temp,1,3)-centroids2(:)').^2;
        voronoi_distances2 = zeros(150,3);
        for i=1:3
            voronoi_distances2(:,i) = (voronoi_distances(:,2*i-1)+voronoi_distances(:,2*i)); % Distances for new clusters
        end
        new_memberships = zeros(150,3);
        if(m>1)
            for i=1:150
                for j=1:3
                    new_memberships(i,j) = sum(voronoi_distances2(i,j)./voronoi_distances2(i,:))^(1/(1-m)); % New memberships for new centroids
                end
            end
        else
           new_memberships = (voronoi_distances2==min(voronoi_distances2,[],2));
        end
        err = sum(abs(membership-new_memberships),'all');
        membership = new_memberships;
    end
    scatter(input_objects(1,:),input_objects(2,:));hold on;
    scatter(centroids(:,1),centroids(:,2),'rd','LineWidth',2);legend('Objects','Centroids');
end