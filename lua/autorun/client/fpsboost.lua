CreateClientConVar( "fpsboost_dontopen", "0", true, false )

surface.CreateFont( "IceFont", {
		font = "CloseCaption_Bold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		bold = true,
		size = 18,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true
	} )

	local function fpsboost(ply)
		local fpsconvar = ply:GetInfoNum( "gmod_mcore_test", 0 )
		local fpscount = math.Round( 1/RealFrameTime() )
		local fpscounttype
		if fpscount >= 160 then
			fpscounttype = "Bien!"
		elseif fpscount <160 and fpscount > 90 then
			fpscounttype = "Bien !"
		else
			fpscounttype = "Parfait"
		end
		if(fpsconvar >= 1) then return end
		
		local FpsMenu = vgui.Create( "DFrame" )
		FpsMenu:SetTitle( "" )
		FpsMenu:SetSize( 0, 0 )
		FpsMenu:SetPos(ScrW()/2-150, ScrH()/2-60 )
		FpsMenu:MakePopup()
		FpsMenu:ShowCloseButton(false)
		FpsMenu:SetDraggable(false)
		FpsMenu:SizeTo( 300, 130, .5, 0, 10)
		FpsMenu.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 139, 255, 250 ) ) 
			draw.RoundedBox( 6, 5, 5, w-10, h-10, Color( 90, 90, 90, 250 ) ) 
		end
		
		local FpsText = vgui.Create( "DLabel", FpsMenu )
		FpsText:SetPos(28, 15 )
		FpsText:SetText( "Souhaitez-vous activer FPS Boost ?" )
		FpsText:SetFont("IceFont")
		FpsText:SizeToContents()
		
		local FpsText2 = vgui.Create( "DLabel", FpsMenu )
		FpsText2:SetPos(28, 38 )
		FpsText2:SetText( "Vos FPS: "..fpscount.." - "..fpscounttype)
		FpsText2:SetFont("IceFont")
		FpsText2:SizeToContents()
		
		
		
		local EnableButton = vgui.Create( "DButton", FpsMenu )
		EnableButton:SetText( "Activer" )
		EnableButton:SetTextColor( Color( 255, 255, 255 ) )
		EnableButton:SetPos( 55, 85 )
		EnableButton:SetSize( 90, 30 )
		EnableButton.Paint = function( self, w, h )	
			if EnableButton:IsHovered() then
				draw.RoundedBox( 4, 0, 0, w, h, Color( 140, 140, 140, 250 ) ) 
			else
				draw.RoundedBox( 4, 0, 0, w, h, Color( 128, 128, 128, 250 ) ) 
			end
		end
		EnableButton.DoClick = function() 
			surface.PlaySound("buttons/button15.wav") 
			local ply = LocalPlayer()
				ply:ConCommand("gmod_mcore_test 1")
				ply:ConCommand("r_queued_ropes 1")
				ply:ConCommand("cl_threaded_bone_setup 1")
				ply:ConCommand("cl_threaded_client_leaf_system 1")
				ply:ConCommand("mat_queue_mode -1")
				ply:ConCommand("r_threaded_renderables 1")
				ply:ConCommand("r_threaded_particles 1")
				ply:ConCommand("M9KGasEffect 0")
				hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
				hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
				hook.Remove("RenderScreenspaceEffects", "RenderBloom")
				hook.Remove("PreRender", "PreRenderFrameBlend")
				hook.Remove("DrawOverlay","sandbox_search_progress")
				hook.Remove("PostRender", "RenderFrameBlend")
				hook.Remove("Think", "DOFThink")
				hook.Remove("CalcView", "rp_deathPOV")
				hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
				chat.AddText( Color( 0, 159, 255 ), "[FpsBoost]", Color( 255, 255, 255 ), " Vos Fps sont a "..math.Round( 1/RealFrameTime() ).." FPS!" )
				chat.AddText( Color( 0, 159, 255 ), "[FpsBoost]", Color( 255, 255, 255 ), " Si vous rencontrez un FPS plus mauvais ou un plantage, utilisez / fpsreset pour réinitialiser vos paramètres: D Utilisez cl_showfps 1 dans la console pour vérifier également votre FPS." )
				FpsMenu:Remove()
		end

		local NoButton = vgui.Create( "DButton", FpsMenu ) 
		NoButton:SetText( "Non Merci" )
		NoButton:SetTextColor( Color( 255, 255, 255 ) )
		NoButton:SetPos( 150, 85 )
		NoButton:SetSize( 90, 30 )
		NoButton.Paint = function( self, w, h )
			if NoButton:IsHovered() then
				draw.RoundedBox( 4, 0, 0, w, h, Color( 140, 140, 140, 250 ) ) 
			else
				draw.RoundedBox( 4, 0, 0, w, h, Color( 128, 128, 128, 250 ) ) 
			end
		end
		NoButton.DoClick = function()
		chat.AddText( Color( 0, 159, 255 ), "[Fps-Boost]", Color( 255, 255, 255 ), ", Si vous changez d'avis, tapez simplement /fpsreset dans le chat." )
			surface.PlaySound("buttons/button15.wav") 
			LocalPlayer():ConCommand("fpsboost_dontopen 1")
			FpsMenu:Remove()
		end
	end

net.Receive("OpenFpsMenu", function()
	local ply = LocalPlayer()
	local fpsconvar2 = ply:GetInfoNum( "fpsboost_dontopen", 0 )
	if(fpsconvar2 >= 1) then return end
	fpsboost(ply)
end)

hook.Add( "OnPlayerChat", "FpsBoost", function( ply, strText)
	local fpsconvar = ply:GetInfoNum( "gmod_mcore_test", 0 )
	strText = string.lower( strText ) 

	if ( strText == "/fpsboost" ) then
		if(fpsconvar >= 1) then 
			chat.AddText( Color( 0, 159, 255 ), "[Fps-Boost]", Color( 255, 255, 255 ), " Vous avez deja le boost !" )
		else
			fpsboost(ply)
		return true 
		end
	end
	
	if ( strText == "/fpsreset" ) then
		if(fpsconvar >= 1) then 
			chat.AddText( Color( 0, 159, 255 ), "[Fps-Boost]", Color( 255, 255, 255 ), " Vous avez réinitialisé vos paramètres FPS Boost !" )
			LocalPlayer():ConCommand("gmod_mcore_test 0")
			LocalPlayer():ConCommand("r_queued_ropes 0")
			LocalPlayer():ConCommand("cl_threaded_bone_setup 0")
			LocalPlayer():ConCommand("cl_threaded_client_leaf_system 0")
			LocalPlayer():ConCommand("mat_queue_mode 0")
			LocalPlayer():ConCommand("r_threaded_renderables 0")
			LocalPlayer():ConCommand("r_threaded_particles 0")
			LocalPlayer():ConCommand("M9KGasEffect 1")

		return true 
		end
	end

end )
