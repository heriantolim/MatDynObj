function set(obj,varargin)
%% Set
%  Add, change, or delete some properties of the object.
%
% Syntax:
%  obj.set(S), where S is a struct with fields 'Field1', 'Field2',... and values
%  Value1, Value2, ... sets or adds the property 'Field1' with Value1, 'Field2'
%  with Value2, and so on.
%
%  obj.set('PropName1',Value1,...) sets the value of the property PropName1 to
%  Value1. PropName1 is added automatically, if it is not a property of the
%  object.
%
%  obj.set({'PropName1','RefName2','RefName3'},Value1,...) leads to one of the
%  following:
%
%     If PropName1 is not a property of the object, then PropName1 is added with
%     a value equals to a struct S.('RefName2').('RefName3')=Value1.
%
%     If PropName1 is a property of the object, then check if obj.('PropName1')
%     is of class DynamicObject. If it is, then repeat the procedure, i.e.
%     obj.('PropName1').set({'RefName2','RefName3'},Value1). If not, then check
%     if obj.('PropName1') is a struct with field 'RefName2'.
%
%     Suppose obj.('PropName1') is not a struct. Then replace the value of
%     obj.('PropName1') with a struct S.('RefName2').('RefName3')=Value1.
%
%     If obj.('PropName1') is a struct without the field 'RefName2', then add
%     the field 'RefName2' to obj.('PropName1') and assign
%     obj.('PropName1').('RefName2') with a struct S.('RefName3')=Value1.
%
%     If obj.('PropName1') is a struct with the field 'RefName2', then check
%     again if obj.('PropName1').('RefName2') is of class DynamicObject, i.e.
%     repeat the procedure. At the last subscript reference, always set
%     obj.('PropName1').('RefName2').('RefName3')=Value1.
%
%  obj.set('PropName1',[],...) removes the property PropName1 from the object,
%  if PropName1 is a property of the object that was added dynamically.
%  Otherwise, calling this will set obj.('PropName1')=[];
%
%  obj.set({'PropName1','RefName2','RefName3'},[],...) leads to one of the
%  following:
%
%     If obj.('PropName1').('RefName2').('RefName3') is not a valid subscripted
%     referencing, then nothing happens.
%
%     Suppose it is a valid subscripted referencing and
%     obj.('PropName1').('RefName2').('RefName3') is of class DynamicObject. If
%     'RefName3' is a property that was added dynamically then remove the
%     object, else do the assignment
%     obj.('PropName1').('RefName2').('RefName3')=[].
%
%     Suppose it is a valid subscripted referencing and
%     obj.('PropName1').('RefName2') is a struct with field 'RefName3' then
%     remove the field 'RefName3'.
%
%     In all other cases, nothing happens.
%
% See also: get.
%
% Requires package:
%  - MatCommon_v1.0.0+
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
	return;
elseif N==1 && isstruct(varargin{1})
	field=fieldnames(varargin{1});
	value=struct2cell(varargin{1});
	numFields=numel(field);
	for i=1:numFields
		obj.set(field{i},value{i});
	end
else
	k=1;
	while k<N
		if ischar(varargin{k})
			refName=varargin(k);
		else
			refName=varargin{k};
		end
		assert(all(cellfun(@isvarname,refName)),...
			'MatDynObj:DynamicObj:set:InvalidInput',...
			['Input to the subscripted reference name must be a valid ',...
				'variable name.']);
		value=varargin{k+1};
		metaInfo=obj.findprop(refName{1});
		numRefs=numel(refName);
		if isempty(metaInfo)
			if isemptynumber(value)
				k=k+2;
				continue
			else
				metaInfo=obj.addprop(refName{1});
			end
		end
		if numRefs==1
			if isempty(value) &&...
				isa(metaInfo,'meta.DynamicProperty')
				delete(metaInfo);
			else
				obj.(refName{1})=value;
			end
		else
			S=obj.(refName{1});
			i=2;
			while i<numRefs && isfield(S,refName{i})
				S=S.(refName{i});
				i=i+1;
			end
			if isa(S,'DynamicObj')
				S.set(refName(i:numRefs),value);
			elseif isemptynumber(value)
				if i==numRefs && isfield(S,refName{i})
					S=rmfield(S,refName{i});
				else
					k=k+2;
				  continue
				end
			else
				i=numRefs+1;
				S=value;
			end
			i=i-1;
			typeSubsArray=cell(1,2*i);
			for j=1:i
				typeSubsArray{2*j-1}='.';
				typeSubsArray{2*j}=refName{j};
			end
			obj=subsasgn(obj,substruct(typeSubsArray{:}),S);
		end
		k=k+2;
	end
	if k<=N
		warning('MatDynObj:DynamicObj:set:MissingValue',...
			'The last assignment is ignored as no value was provided.');
	end
end

end