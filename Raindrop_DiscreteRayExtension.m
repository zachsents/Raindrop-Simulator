clear
clc
close all


speeds = linspace(0, 3, 20);
runs = zeros(100, length(speeds));

for i = 1:size(runs, 2)
    fprintf("Speed: %f\n", speeds(i))
    for j = 1:size(runs, 1)
        runs(j, i) = runSim(speeds(i), 200, 0.1, false);
        fprintf(".")
    end
    fprintf("\n%d runs done.\n\n", size(runs, 1))
end

plot(speeds, mean(runs), "o", "LineWidth", 2);
xlabel("Walking/Running Speed (relative to rain speed)")
ylabel("Average Hits")

mean(runs)


% runSim(2, 200, 0.01, false)

function hits = runSim(person_speed_rel, height, density, visualize)

    % set viewing window
    viewing_window = [-1, 3, 0, 4];

    % define "person" bounding box
    person_x = [0 0 1 1];
    person_y = [0 2 2 0];
    
    % plot player
    if visualize
        hold on
        axis equal
        axis(viewing_window)
        plot(person_x, person_y, 'r', 'LineWidth', 2)
    end
    
    % calculate important numbers
    width = height * person_speed_rel + 1;
    num_raindrops = round(density * width * height);
    
    % define raindrops
    raindrops_x = rand(num_raindrops, 1) .* width;
    raindrops_y = rand(num_raindrops, 1) .* height;
    
    % keeping track of hits
    hits = 0;

    % convert raindrops to lines
    for i = 1:length(raindrops_x)
        ray_y = [raindrops_y(i) 0];
        ray_x = [raindrops_x(i) raindrops_x(i)-person_speed_rel*raindrops_y(i)];
        
        % test intersection
        test_points_x = ray_x(1):-0.05:ray_x(2);
        test_points_y = linspace(ray_y(1), ray_y(2), length(test_points_x));
        in = inpolygon(test_points_x, test_points_y, person_x, person_y);
        
        hits = hits + any(in);
        
        % plot
        if visualize
            plot(ray_x, ray_y, 'b.-')
            %plot(test_points_x, test_points_y, 'b.')
            
            if any(in)
                int_x = test_points_x(in);
                int_y = test_points_y(in);
                plot(int_x(1), int_y(1), 'go')
            end
        end
    end
    
    if visualize
        fprintf("\nHits: %d\n", hits);
    end
end

