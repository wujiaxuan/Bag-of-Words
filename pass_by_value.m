function [] = pass_by_value(a)
names = a.names
a.names{1}
end