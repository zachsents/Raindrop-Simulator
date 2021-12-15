clear
clc
close all

speeds = linspace(0, 2, 10);
runs = zeros(20, length(speeds));

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

% runSim(1, 200, 0.1, true)

function hits = runSim(person_speed_rel, height, density, visualize)

    % set viewing window
    viewing_window = [0, 100, 0, 100];

    % define "person" bounding box
    margin = 0;
    person_x = ones(1, 4) .* margin + [0 0 1 1];
    person_y = [0 2 2 0];
    
    % calculate important numbers
    width = height * person_speed_rel + margin + 1;
    num_raindrops = round(density * width * height);
    rain_speed = 0.05;
    person_speed = person_speed_rel * rain_speed;
    
    % define raindrops
    raindrops_x = rand(num_raindrops, 1) .* width;
    raindrops_y = rand(num_raindrops, 1) .* height;

    % plotting
    handle = [];
    if visualize
        axis equal
        hold on
        handle = plot(raindrops_x, raindrops_y, 'b.');
        plot(person_x, person_y, 'r', 'LineWidth', 2)
        axis(viewing_window)
    end    

    % keeping track of hits
    hits = 0;

    while ~isempty(raindrops_x)
        % move raindrops
        raindrops_y = raindrops_y - rain_speed;

        % move person (virtually)
        raindrops_x = raindrops_x - person_speed;

        % destroy if they're below the ground
        raindrops_x = raindrops_x(raindrops_y >= 0);
        raindrops_y = raindrops_y(raindrops_y >= 0);

        % test collision
        in = inpolygon(raindrops_x, raindrops_y, person_x, person_y);
        hits = hits + sum(in);
        if visualize && sum(in) > 0
            fprintf(".");
        end

        % destroy collided raindrops
        raindrops_x = raindrops_x(~in);
        raindrops_y = raindrops_y(~in);
        
        if visualize
            % redraw
            handle.XData = raindrops_x;
            handle.YData = raindrops_y;
            
            % pause for viewing pleasure
            pause(0.0001)
        end
    end

    if visualize
        fprintf("\nHits: %d\n", hits);
    end
    close all

end

