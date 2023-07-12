local _, Addon = ...;
local Color = Addon:NewModule("Color");

Color.PREFIX = "FF33FF99";
Color.MESSAGE = "FFFFFFFF";
Color.SUCCESS = "FF33FF33";
Color.WARNING = "FFFFFF33";
Color.CAUTION = "FFFF9933";
Color.ERROR = "FFFF3333";

function Color:WrapText(text, color)
  return WrapTextInColorCode(tostring(text), assert(color));
end

function Color:Class(text, className)
  return self:WrapText(text, RAID_CLASS_COLORS[className].colorStr);
end

function Color:Faction(text, faction)
  return self:WrapText(text, GetFactionColor(faction):GenerateHexColor());
end

function Color:Prefix(text)
  return self:WrapText(text, self.PREFIX);
end

function Color:Message(text)
  return self:WrapText(text, self.MESSAGE);
end

function Color:Success(text)
  return self:WrapText(text, self.SUCCESS);
end

function Color:Warning(text)
  return self:WrapText(text, self.WARNING);
end

function Color:Caution(text)
  return self:WrapText(text, self.CAUTION);
end

function Color:Error(text)
  return self:WrapText(text, self.ERROR);
end