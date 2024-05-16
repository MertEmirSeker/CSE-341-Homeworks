classify(SepalLength, SepalWidth, PetalLength, PetalWidth) :-
    % Check the petal width to determine the class
    (   PetalWidth =< 0.8
    % If petal width is less than or equal to 0.8, it's Iris-setosa
    ->  write('Iris-setosa')
    % Otherwise, check further conditions
    ;   PetalWidth > 0.8,
        (   PetalWidth =< 1.75
        % For petal width less than or equal to 1.75, check petal length
        ->  (   PetalLength =< 4.95
            % Check petal width for further classification
            ->  (   PetalWidth =< 1.65
                % If petal width is less than or equal to 1.65, it's Iris-versicolor
                ->  write('Iris-versicolor')
                % Else, it's Iris-virginica
                ;   PetalWidth > 1.65
                ->  write('Iris-virginica')
                )
            % For petal length greater than 4.95, check further
            ;   PetalLength > 4.95
            ->  (   PetalWidth =< 1.55
                % If petal width is less than or equal to 1.55, it's Iris-virginica
                ->  write('Iris-virginica')
                % Check petal length for further classification
                ;   PetalWidth > 1.55,
                    (   PetalLength =< 5.45
                    % If petal length is less than or equal to 5.45, it's Iris-versicolor
                    ->  write('Iris-versicolor')
                    % Else, it's Iris-virginica
                    ;   PetalLength > 5.45
                    ->  write('Iris-virginica')
                    )
                )
            )
        % For petal width greater than 1.75, check petal length
        ;   PetalWidth > 1.75,
            (   PetalLength =< 4.85
            % Check sepal width for further classification
            ->  (   SepalWidth =< 3.1
                % If sepal width is less than or equal to 3.1, it's Iris-virginica
                ->  write('Iris-virginica')
                % Else, it's Iris-versicolor
                ;   SepalWidth > 3.1
                ->  write('Iris-versicolor')
                )
            % If petal length is greater than 4.85, it's Iris-virginica
            ;   PetalLength > 4.85
            ->  write('Iris-virginica')
            )
        )
    ).


% classify(4.9, 2.4, 3.3, 1.0).

