function value=get(obj,varargin)
%% Get
%  Retrieve the values of the object's properties.
%
% Syntax:
%  value=obj.get('PropName',...) returns the value of the property 'PropName',
%  if it is a property of the object. Otherwise an empty number is returned.
%
%  value=obj.get({'PropName1','RefName2','RefName3'},...) returns the value of
%  obj.('PropName1').('RefName2').('RefName3'), if the input references makes a
%  valid subscripted referencing of the object. Otherwise an empty number is
%  returned.
%
%  When multiple properties are queried, the output is a cell whose elements
%  equal to the property values in one-to-one correspondence.
%   
% See also: set.
%
% Tested on:
%  - MATLAB R2013b
%
% Copyright: Herianto Lim (http://heriantolim.com)
% Licensing: GNU General Public License v3.0
% First created: 01/04/2013
% Last modified: 09/04/2013

N=numel(varargin);
if N==0
	value=[];
else
	value=cell(1,N);
	k=0;
	while k<N
		k=k+1;
		if ischar(varargin{k})
			refName=varargin(k);
		else
			refName=varargin{k};
		end
		assert(all(cellfun(@isvarname,refName)),...
			'MatDynObj:DynamicObj:get:InvalidInput',...
			['Input to the subscripted reference names must be ',...
				'a valid variable name.']);
		if obj.issubsref(refName{:})
			numRefs=numel(refName);
			typeSubsArray=cell(1,2*numRefs);
			for i=1:numRefs
				typeSubsArray{2*i-1}='.';
				typeSubsArray{2*i}=refName{i};
			end
			value{k}=subsref(obj,substruct(typeSubsArray{:}));
		else
			value{k}=[];
		end
	end
	if N==1
		value=value{1};
	end
end

end