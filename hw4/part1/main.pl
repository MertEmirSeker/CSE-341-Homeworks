% Places
place(admin_office).
place(engineering_bld).
place(lecture_hall_a).
place(library).
place(cafeteria).
place(social_sciences_bld).
place(institute_x).
place(institute_y).

% Paths
path(admin_office, library, 1).
path(library, admin_office, 1).
path(library, social_sciences_bld, 2).
path(social_sciences_bld, library, 2).
path(social_sciences_bld, cafeteria, 2).
path(cafeteria, social_sciences_bld, 2).
path(engineering_bld, lecture_hall_a, 2).
path(lecture_hall_a, engineering_bld, 2).
path(lecture_hall_a, institute_y, 3).
path(institute_y, lecture_hall_a, 3).
path(institute_y, library, 3).
path(library, institute_y, 3).
path(admin_office, engineering_bld, 3).
path(engineering_bld, admin_office, 3).
path(admin_office, cafeteria, 4).
path(cafeteria, admin_office, 4).
path(library, cafeteria, 5).
path(cafeteria, library, 5).
path(engineering_bld, library, 5).
path(library, engineering_bld, 5).
path(institute_x, social_sciences_bld, 8).
path(social_sciences_bld, institute_x, 8).

% Finding all paths between two places
find_paths(Start, End, Visited, [End|Visited], Length) :-
    path(Start, End, Length).

find_paths(Start, End, Visited, Path, Length) :-
    path(Start, Middle, MiddleLength),
    Middle \== End,
    \+ member(Middle, Visited),
    find_paths(Middle, End, [Middle|Visited], Path, RestLength),
    Length is MiddleLength + RestLength.

% Finding shortest path between two places
shortest_path(Start, End, ShortestPath, ShortestLength) :-
    setof(Length-Path, find_paths(Start, End, [], Path, Length), [ShortestLength-ShortestPath|_]).


% Delivery Personnel
% delivery_person(ID, CapacityKG, WorkHours, CurrentJob, CurrentLocation).
delivery_person(d1, 10, 12, none, library).
delivery_person(d2, 20, 8, o2, engineering_bld).
delivery_person(d3, 15, 4, none, cafeteria).

% Delivery Objects
% delivery_object(ID, WeightKG, PickupPlace, DropOffPlace, Urgency, DeliveryPersonID).
delivery_object(o1, 5, library, institute_x, high, none).
delivery_object(o2, 3, engineering_bld, lecture_hall_a, medium, d2).
delivery_object(o3, 2, cafeteria, social_sciences_bld, low, none).
delivery_object(o4, 4, lecture_hall_a, institute_y, high, none).
delivery_object(o5, 6, social_sciences_bld, admin_office, medium, none).

% Checking if a place is valid
valid_place(Place) :- place(Place).

% Check if path exists and find time
find_path_time(Start, End, Time) :-
    shortest_path(Start, End, _, Time).

% Availability check for delivery personnel
available_delivery_person(PersonID, ObjectID, TimeToComplete) :-
    delivery_object(ObjectID, Weight, PickupPlace, DropOffPlace, _, none),
    delivery_person(PersonID, Capacity, _, none, CurrentLocation),
    Weight =< Capacity,
    find_path_time(CurrentLocation, PickupPlace, Time1),
    find_path_time(PickupPlace, DropOffPlace, Time2),
    TimeToComplete is Time1 + Time2.

% If the object is already in delivery, find the person delivering it
delivery_in_progress(ObjectID, PersonID) :-
    delivery_object(ObjectID, _, _, _, _, PersonID),
    PersonID \= none.

is_delivery_available(ObjectID) :-
    delivery_in_progress(ObjectID, PersonID),
    !,  % Cut to prevent further backtracking
    format('Object is already in delivery by ~w~n', [PersonID]).

is_delivery_available(ObjectID) :-
    % Find all available delivery persons and the time it takes for them to complete the delivery
    findall(PersonID-TimeToComplete, available_delivery_person(PersonID, ObjectID, TimeToComplete), Results),
    Results \= [],
    !, % Cut to prevent backtracking
    print_delivery_options(Results).

is_delivery_available(_) :-
    % If there are no available delivery persons or the object is not found
    write('No available delivery person or object not found.').


% Helper predicate to print available delivery options
print_delivery_options([]).
print_delivery_options([PersonID-TimeToComplete|Rest]) :-
    % Check if PersonID and TimeToComplete are instantiated variables
    var(PersonID), var(TimeToComplete), !,
    print_delivery_options(Rest).
print_delivery_options([PersonID-TimeToComplete|Rest]) :-
    format('Available delivery person: ~w, Total time to complete: ~w~n', [PersonID, TimeToComplete]),
    print_delivery_options(Rest).


% Terminal Examples

% ?- shortest_path(engineering_bld, social_sciences_bld, ShortestPath, ShortestLength).
% ?-sho1rtest_path(engineering_bld, institute_x, ShortestPath, ShortestLength).

% ?- available_delivery_person(d2, o1, TimeToComplete).

check_delivery_availability(Object) :-
    format('Object ~w:~n', [Object]),
    is_delivery_available(Object).

all_objects :-
    check_delivery_availability(o1),
    check_delivery_availability(o2),
    check_delivery_availability(o3),
    check_delivery_availability(o4),
    check_delivery_availability(o5).
