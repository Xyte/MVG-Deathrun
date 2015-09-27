local Vecmeta = FindMetaTable( "Vector" )

function Vecmeta:Round( dec )
	local dec = dec or 0
	local x, y, z = self.x, self.y, self.z
	self:Set( Vector( math.Round( x, dec ), math.Round( y, dec ), math.Round( z, dec ) ) )
end

net.Receive( "send_placement_mode", function()
	local m = net.ReadFloat()
	if m == 1 then
		ClientStartPlacement()
	else
		ClientStopPlacement()
	end
end )

local trans_type = { "Runner start", "Death start" }

function ClientStartPlacement()
	local p1, p2, p3, p4
	local MadeFirstPoint = false
	local MadeSecondPoint = false
	local RunnerOrDeath = 1
	local mat_laser = Material( "cable/redlaser" )
	local nextClickTime = CurTime() + 1

	Box = ClientsideModel( "models/hunter/blocks/cube025x025x025.mdl", RENDERGROUP_OPAQUE )
	Box:SetMaterial( "models/wireframe" )
	Box:SetModelScale( 0.1, 1 )
	Box:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	Box:Spawn()

	hook.Add( "Think", "PlacementBox", function()
		local hit = LocalPlayer():GetEyeTrace()

		if hit.HitWorld then

			if not MadeSecondPoint and p1 then
				p3 = hit.HitPos
				p3:Round()
				p2 = Vector( p1.x, p3.y, p1.z )
				p4 = Vector( p3.x, p1.y, p1.z )
			elseif p1 and p3 then
				p2 = Vector( p1.x, p3.y, p1.z )
				p4 = Vector( p3.x, p1.y, p1.z )
			end

			Box:SetPos( hit.HitPos )

			if CurTime() > nextClickTime then
				if input.IsMouseDown( MOUSE_LEFT ) then
					if InPointSelection then return end
					if not p1 then
						p1 = hit.HitPos
						p1:Round()
						MadeFirstPoint = true
					else
						p3 = hit.HitPos
						p3:Round()
						MadeSecondPoint = true
					end
					nextClickTime = CurTime() + 0.5
				elseif input.IsMouseDown( MOUSE_RIGHT ) then
					if InPointSelection then return end
					if MadeSecondPoint then 
						p3 = nil
						MadeSecondPoint = false
					elseif MadeFirstPoint then
						p1 = nil
						MadeFirstPoint = false
					end
					nextClickTime = CurTime() + 0.5
				elseif input.IsKeyDown( KEY_LALT ) then
					if RunnerOrDeath == 1 then
						chat.AddText(color_white, "Runner start area has been saved.")
						SendPlacementData( { P1 = Vector( p1.x, p1.y, p1.z+5 ), P3 = Vector( p3.x, p3.y, p3.z+5 ), TYPE = "Runner" } )
					else
						chat.AddText(color_white, "Death start area has been saved.")
						SendPlacementData( { P1 = Vector( p1.x, p1.y, p1.z+5 ), P3 = Vector( p3.x, p3.y, p3.z+5 ), TYPE = "Death" } )
					end
					nextClickTime = CurTime() + 0.5
				elseif input.IsKeyDown( KEY_SPACE ) then
					if #trans_type < RunnerOrDeath then RunnerOrDeath = RunnerOrDeath + 1 else RunnerOrDeath = 1 end
					nextClickTime = CurTime() + 0.5
				end
			end
		end
	end )

	hook.Add( "PostDrawOpaqueRenderables", "PreviewBox", function()
		if p1 and p3 then
			render.SetMaterial( mat_laser )
			render.DrawBeam( p1, p2, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
			render.DrawBeam( p2, p3, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
			render.DrawBeam( p3, p4, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
			render.DrawBeam( p4, p1, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
		end
	end )

	hook.Add( "HUDPaint", "PlacementGuides", function()
		draw.SimpleText( "LEFT CLICK - Place point", "default", 20, ScrH() / 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "RIGHT CLICK - Remove point", "default", 20, ScrH() / 3 + 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "SPACE - Toggle Start/End | " .. trans_type[ RunnerOrDeath ], "default", 20, ScrH() / 3 + 40, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( "LEFT ALT - Save placement", "default", 20, ScrH() / 3 + 60, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end )

end

function ClientStopPlacement()
	hook.Remove( "Think", "PlacementBox" )
	hook.Remove( "PostDrawOpaqueRenderables", "PreviewBox" )
	hook.Remove( "HUDPaint", "PlacementGuides" )
	if IsValid( Box ) then
		Box:Remove()
	end
end

function SendPlacementData( tblData )
	net.Start( "send_placement_data" )
	net.WriteTable( tblData )
	net.SendToServer()
end
