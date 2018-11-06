classdef DynamicObj < dynamicprops
%% Object with Dynamic Properties
%  This class extends the dynamicprops class. It provides convinient methods to
%  dynamically set and get the value of the object properties.
%
%  To add one or more properties, execute:
%  obj.set('PropName1',PropValue1,'PropName2',PropValue2,...)
%
%  To remove one or more properties, execute:
%  obj.set('PropName1',[],'PropName2',[],...)
%
%  To retrieve the value of some properties, execute:
%  value=obj.get('PropName1','PropName2',...)
%
%  If the queried property is not found then the get method returns an empty
%  number.
%
%  Assignment with a struct with a series of concatenating fields is also
%  supported. See the set method for more info.
%
% Public methods:
%   rmprop: Remove a property from the object.
%
%   set: Add or set the values of one or more properties.
%
%   get: Retrieve the values of one or more properties.
%
%   issubsref: Check if input is a valid subscripted referencing for the
%              object.
%
% Tested on:
%  - MATLAB R2013b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 01/04/2013
% Last modified: 09/04/2013

methods
	rmprop(obj,propName)
	set(obj,varargin)
	value=get(obj,varargin)
	tf=issubsref(obj,varargin)
end

end