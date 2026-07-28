local PersonalInfoUtils = {}

function PersonalInfoUtils:CheckPoseEnough(Avatar, PoseId)
  local GestureCfg = DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId]
  if not GestureCfg then
    return false
  end
  local GestureTag = GestureCfg.GestureTag
  if GestureTag == CommonConst.GestureTagType.Gesture then
    local ResourceId = GestureCfg.ReleaseWheel
    return nil ~= ResourceId and self:GetResourceNum(Avatar, ResourceId) > 0
  elseif GestureTag == CommonConst.GestureTagType.Pose then
    return self:HasPersonalInfoGesture(Avatar, PoseId)
  end
  return false
end

function PersonalInfoUtils:GetResourceNum(Avatar, ResourceId)
  if not Avatar or not ResourceId then
    return 0
  end
  if type(Avatar.GetResourceNum) == "function" then
    return Avatar:GetResourceNum(ResourceId) or 0
  end
  local Resource = Avatar.Resources and Avatar.Resources[ResourceId]
  return Resource and Resource.Count or 0
end

function PersonalInfoUtils:HasPersonalInfoGesture(Avatar, PoseId)
  local PersonalInfoGestureList = Avatar and Avatar.PersonalInfoGestureList
  if not PersonalInfoGestureList then
    return false
  end
  if PersonalInfoGestureList.HasValue then
    return PersonalInfoGestureList:HasValue(PoseId)
  end
  return CommonUtils.HasValue(PersonalInfoGestureList, PoseId)
end

return PersonalInfoUtils
