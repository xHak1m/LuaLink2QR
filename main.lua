local cjson = require("cjson")

local function library(title, fields)
	return
	{
		form = {
			title = title,
			fields = fields
		}
	}
end

local function textbox(name, label, required, initial)
	return
	{
		type = "text",
		name = name,
		label = label,
		required = required,
		initial = initial
	}
end

local function number(name, label, required, initial)
	return
	{
		type = "numeric",
		name = name,
		label = label,
		required = required,
		initial = initial
	}
end

local function dropdown(name, label, required, initial)
	return
	{
		type = "choice",
		name = name,
		label = label,
		required = required,
		options = initial
	}
end

local function checkbox(name, label, initial)
	return
	{
		type = "checkbox",
		name = name,
		label = label,
		initial = initial
	}
end

local function divider()
	return
	{
		type = "divider"
	}
end

local function build(menu)
	local main = app.jsonForm(cjson.encode(menu))
	if (not main or (main == "")) then
		return nil
	end
	local result = cjson.decode(main)
	for _, field in ipairs(menu.form.fields) do
		if field.type == "numeric" then
			local value = tonumber(result[field.name]) or 0
			if value % 1 == 0 then
				result[field.name] = math.tointeger and math.tointeger(value) or value
			else
				result[field.name] = value
			end
		end
	end
	return result
end

LuaLink2QR = build(library("LuaLink2QR", {
	textbox("url", "Enter link here:", true, "https://example.com"),
}))

if not LuaLink2QR then
	app.toast("User has cancelled the session.")
	return
end

app.qrCode(LuaLink2QR.url)
