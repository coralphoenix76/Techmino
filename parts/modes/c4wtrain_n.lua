local rnd,min=math.random,math.min
local rem=table.remove
local function check_c4w(P)
	if P.lastPiece.row>0 then
		for _=1,#P.clearedRow do
			P.field[#P.field+1]=FREEROW.get(20)
			P.visTime[#P.visTime+1]=FREEROW.get(20)
			for i=4,7 do P.field[#P.field][i]=0 end
		end
		if P.combo>P.modeData.point then
			P.modeData.point=P.combo
		end
		if P.stat.row>=100 then
			P:win("finish")
		end
	end
end

return{
	color=COLOR.green,
	env={
		drop=30,lock=60,infHold=true,
		dropPiece=check_c4w,
		freshLimit=15,ospin=false,
		bg="rgb",bgm="oxygen",
	},
	pauseLimit=true,
	load=function()
		PLY.newPlayer(1)
		local P=PLAYERS[1]
		local F=P.field
		for i=1,24 do
			F[i]=FREEROW.get(20)
			P.visTime[i]=FREEROW.get(20)
			for x=4,7 do F[i][x]=0 end
		end
		if rnd()<.6 then
			local initCell={11,14,12,13,21,24}
			for _=1,3 do
				_=rem(initCell,rnd(#initCell))
				F[math.floor(_/10)][3+_%10]=20
			end
		else
			local initCell={11,12,13,14,21,22,23,24}
			rem(initCell,rnd(5,8))
			rem(initCell,rnd(1,4))
			for _=1,6 do
				_=rem(initCell,rnd(#initCell))
				F[math.floor(_/10)][3+_%10]=20
			end
		end
	end,
	mesDisp=function(P)
		setFont(45)
		mStr(P.combo,69,310)
		mStr(P.modeData.point,69,400)
		mText(drawableText.combo,69,358)
		mText(drawableText.maxcmb,69,450)
	end,
	score=function(P)return{min(P.modeData.point,100),P.stat.time}end,
	scoreDisp=function(D)return D[1].." Combo   "..TIMESTR(D[2])end,
	comp=function(a,b)return a[1]>b[1]or a[1]==b[1]and a[2]<b[2]end,
	getRank=function(P)
		local L=P.stat.row
		if L==100 then
			local T=P.stat.time
			return
			T<=32 and 5 or
			T<=50 and 4 or
			T<=80 and 3 or
			2
		else
			return
			L>=60 and 2 or
			L>=30 and 1 or
			L>=10 and 0
		end
	end,
}