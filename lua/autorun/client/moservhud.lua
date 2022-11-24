local hide = {
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_EntityDisplay"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_Hungermod"] = true,
	["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHudAmmo"] = true,
    ["CHudHintDisplay"] = true,
    ["CHudZoom"] = true,
    ["CHudCrosshair"] = false,
}

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")
    -- Log to client console
    MsgC(Color(255, 20, 20, 220), "[MOServ] ", Color(200, 200, 200, 220), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)
 
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
    if ( hide[ name ] ) then return false end
end )
 
surface.CreateFont("HudPersoTime", {
    font = "Trebuchet18",
    size = 13,
    weight = 1200,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})
 
local function drawCircl( x, y, radius, seg, ang )
    local cir = {}
    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, (ang/5) do
        local a = math.rad( ( i / (ang/5) ) * -ang +180)
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end
    draw.NoTexture()
    surface.DrawPoly( cir )
end
 
-- HUD
hook.Add( "HUDPaint", "Hudmontre", function()
 
-- Variables
local wi = ScrW()
local he = ScrH()
local montre = Material("moserv/hudmontre.png")
local Rotating = math.sin(CurTime() * 1.5)
local backwards = 0
local health = LocalPlayer():Health()
local armor = LocalPlayer():Armor()
local nourriture = LocalPlayer():getDarkRPVar("Energy")
local torchweight = LocalPlayer():GetNWInt("Flash")*wi/1680/100*149

    if Rotating < 0 then
        Rotating = 1 - (1 + Rotating)
        backwards = 360
    end
 
	if HudOuvert then
	 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( montre )
		surface.DrawTexturedRect( wi/3+wi/2, he/10+he/2, wi/6, he/2.5 )
		surface.SetDrawColor(255, 255, 255, 255)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/50, he/50, 360)
	 
	-- Vie

		if health > 100 then
		    health = 100
		end

		-- La vie
		surface.SetDrawColor(255, 0, 0)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/25, he/25, health*360/100)

        -- Séparation entre la vie et l'armure
		surface.SetDrawColor(0, 0, 0)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/34, he/34, 360)

	-- Armure

		if armor > 100 then
		    armor = 100
		end

		surface.SetDrawColor(0,0,235, 255)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/36, he/36, armor*360/100)

		-- Séparation entre l'armure et la faim
		surface.SetDrawColor(0, 0, 0)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/43, he/43, 360)

	-- Nouriture

		if nourriture > 100 then
		    nourriture = 100
		end

		surface.SetDrawColor(0, 204, 0)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/48, he/48, nourriture*360/100)
	 
		-- Disque centrale avec le logo
		surface.SetDrawColor(0, 0, 0)
		drawCircl(wi/2.25+wi/2.1, he/3.4+he/2, wi/85, he/85, 360)

		-- Heure
		local Timestamp = os.time()
		draw.DrawText( os.date( "%H:%M" , Timestamp ), "HudPersoTime", wi/2.53+wi/2.1, he/4.65+he/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

	-- Lampe
		draw.RoundedBox( 5, wi/2.5+wi/2.1, he/2.7+he/2, wi/11-5, he/80, Color(15, 15, 15, 255))
		draw.RoundedBox( 5, wi/2.5+wi/2.1, he/2.7+he/2, torchweight, he/80, Color(255, 255, 50, 255))

		if LocalPlayer():GetNWInt('Flash') <= 45 then
			draw.DrawText( math.Round(LocalPlayer():GetNWInt('Flash')).."%", "HudPersoTime", wi/2.28+wi/2.1, he/2.71+he/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		elseif LocalPlayer():GetNWInt('Flash') >= 55 then
			draw.DrawText( math.Round(LocalPlayer():GetNWInt('Flash')).."%", "HudPersoTime", wi/2.28+wi/2.1, he/2.71+he/2, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end

	end
end)

-- HUD Montre 
hook.Add("Move","Affichageplusinfosurlateteouverturedumenu", function()
    if input.WasKeyPressed( KEY_C ) then
	    if HudOuvert then     
	        HudOuvert = false
	    else
	        HudOuvert = true
	    end
    end
end)