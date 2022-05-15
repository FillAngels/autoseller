script_name("AutoSeller")
script_author("Fill_Angels")
script_version("1.0 release")

require "lib.moonloader"
local imgui = require "imgui"
local inicfg = require "inicfg"
local encoding = require 'encoding'
local ev = require 'lib.samp.events'
local memory = require 'memory'

encoding.default = 'CP1251'
u8 = encoding.UTF8

local cfg = inicfg.load({
    config = { 
        vr = "",
        fam = "",
        j = "",
        s = "",
        ad = "",
		oX = 290,
		oY = 100,
    },
    interface = {
        vr_checkbox = false,
        fam_checkbox = false,
        j_checkbox = false,
        s_checkbox = false,
        ad_checkbox = false,
        vr_slider = 1,
        fam_slider = 1,
        j_slider = 1,
        s_slider = 1,
        ad_slider = 1,
        ad_radiobutton = 1,
        theme_id = 0,
    }
}, "AutoSeller.ini")

stat = { ['act'] = false}

-- imgui window
local main_window_state = imgui.ImBool(false)

-- imgui checkbox
local vr_check = imgui.ImBool(cfg.interface.vr_checkbox)
local fam_check = imgui.ImBool(cfg.interface.fam_checkbox)
local j_check = imgui.ImBool(cfg.interface.j_checkbox)
local s_check = imgui.ImBool(cfg.interface.s_checkbox)
local ad_check = imgui.ImBool(cfg.interface.ad_checkbox)

-- imgui buffer
local vr = imgui.ImBuffer(256)
local fam = imgui.ImBuffer(256)
local j = imgui.ImBuffer(256)
local s = imgui.ImBuffer(256)
local ad = imgui.ImBuffer(256)

-- imgui slider
local vr_slider = imgui.ImInt(cfg.interface.vr_slider)
local fam_slider = imgui.ImInt(cfg.interface.fam_slider)
local j_slider = imgui.ImInt(cfg.interface.j_slider)
local s_slider = imgui.ImInt(cfg.interface.s_slider)
local ad_slider = imgui.ImInt(cfg.interface.ad_slider)

-- imgui radiobutton
local ad_radiobutton = imgui.ImInt(cfg.interface.ad_radiobutton)

-- imgui combo
local themes_combo = imgui.ImInt(0)

-- other
local delay = 0.5

local tempLeaders = {
    [1] = u8'SAPD',
    [2] = u8'FBI',
    [3] = u8'Подразделение [ВМФ]',
    [4] = u8'Мин.Здрав',
    [5] = u8'La Cosa Nostra',
    [6] = u8'Yakuza',
    [7] = u8'Мэрия',
    [8] = u8'Недоступно',
    [9] = u8'Недоступно',
    [10] = u8'Недоступно',
    [11] = u8'Недоступно',
    [12] = u8'Ballas Gang',
    [13] = u8'Vagos Gang',
    [14] = u8'Russian Mafia',
    [15] = u8'Grove Street Gang',
    [16] = u8'San News',
    [17] = u8'Aztecas Gang',
    [18] = u8'Rifa Gang',
    [19] = u8'Подразделение [СВ]',
    [20] = u8'Недоступно',
    [21] = u8'Недоступно',
    [22] = u8'Недоступно',
    [23] = u8'Hitmans',
    [24] = u8'Street Racers',
    [25] = u8'S.W.A.T',
    [26] = u8'Правительство',
    [27] = u8'Подразделение [ВВС]',
    
}

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end 
    
    autoupdate("https://raw.githubusercontent.com/FillAngels/autoseller/main/AutoSeller.lua", '['..string.upper(thisScript().name)..']: ', "vk.com/homkarp993")
	
	if not doesFileExist(getWorkingDirectory()..'\\config\\AutoSeller.ini') then inicfg.save(cfg, 'AutoSeller.ini') end

    sampAddChatMessage("[AutoSeller]: {FFFFFF}Скрипт загружен, для настройки введите /as", 0x5CBCFF)

    sampRegisterChatCommand("as", cmd_imgui)
	sampRegisterChatCommand("reload", reloading)
	sampRegisterChatCommand('afk', aAfk)
	sampRegisterChatCommand('flip', flipCar)
	sampRegisterChatCommand('srep',function()
        sampSendChat('/o Администрация ждёт ваших репортов! (/mm > Репорт)')
    end)
	sampRegisterChatCommand('1rep',function()
        sampSendChat('/o Администрация ждёт ваших репортов! (/mm > Репорт)')
    end)
    
	writeMemory(7634870, 1, 0, 0)
    writeMemory(7635034, 1, 0, 0)
    memory.hex2bin('5051FF1500838500', 7623723, 8)
    memory.hex2bin('0F847B010000', 5499528, 6)
	
	while true do
    	wait(0)
		vr.v = cfg.config.vr
		fam.v = cfg.config.fam
		j.v = cfg.config.j
		s.v = cfg.config.s
		ad.v = cfg.config.ad
		themes_combo.v = cfg.interface.theme_id
		styles = cfg.interface.theme_id
		if main_window_state.v == true then
			lockPlayerControl(true)
		else
			lockPlayerControl(false)
		end
		if stat['act'] == true and vr_check.v == false and fam_check.v == false and j_check.v == false and ad_check.v == false and s_check.v == false then 
			sampAddChatMessage("[AutoSeller]: {FFFFFF}Произошла ошибка, были сняты все CheckBox'ы ", 0x5CBCFF)
			stat['act'] = false
		end
    end
end

function piar_fam()
	while stat['act'] do
		if fam_check.v == true then
			sampSendChat("/a админы 1-16 LVL работаем чистим /replist иначе получите выговор!!!")
			wait(1000)
			sampSendChat("/a админы 1-16 LVL работаем чистим /replist иначе получите выговор!!!")
			wait(1000)
			sampSendChat("/a админы 1-16 LVL работаем чистим /replist иначе получите выговор!!!")
		end
    	wait(fam_slider.v*60000)
	end
end

function flipCar()
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        local x, y, z = getCarCoordinates(veh)
        setCarCoordinates(veh, x, y, z)
		sampAddChatMessage("[AutoSeller]{FFFFFF}: Вы флипнули свою машину!", 0x5CBCFF)
	end
end

function imgui.HelpMarker(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function aAfk()
    actAFK = not actAFK
    if actAFK then
        writeMemory(7634870, 1, 1, 1)
        writeMemory(7635034, 1, 1, 1)
        memory.fill(7623723, 144, 8)
        memory.fill(5499528, 144, 6)
        addOneOffSound(0.0, 0.0, 0.0, 1136)
        printString('~g~ FK ON', 2000)
    else
        writeMemory(7634870, 1, 0, 0)
        writeMemory(7635034, 1, 0, 0)
        memory.hex2bin('5051FF1500838500', 7623723, 8)
        memory.hex2bin('0F847B010000', 5499528, 6)
        addOneOffSound(0.0, 0.0, 0.0, 1136)
        printString('~r~ FK OFF', 2000)
    end
end

function piar_j()
	wait(500)
	while stat['act'] do
		if j_check.v == true then
			sampSendChat("/a " .. u8:decode(cfg.config.j))
			wait(1000)
			sampSendChat("/vad " .. u8:decode(cfg.config.j))
			wait(1000)
			sampSendChat("/hc " .. u8:decode(cfg.config.j))
		end
    	wait(j_slider.v*60000)
	end
end

function piar_s()
	wait(1000)
	while stat['act'] do
		if s_check.v == true then
			sampSendChat("/s введи промокод: " .. u8:decode(cfg.config.s))
			wait(1200)
			sampSendChat("/s и получи VIP статус на 9 дней и Хелперку совершенно бесплатно!!")
		end
    	wait(s_slider.v*60000)
	end
end

function piar_ad()
	wait(1500)
	while stat['act'] do
		if ad_check.v == true and cfg.interface.ad_radiobutton == 1 then
			sampSendChat("/a Свободна должность - ГА по Админам")
			wait(750)
			sampSendChat("/a Критерии: 16 lvl, онлайн 5+, следить за /replist и админами")
			wait(750)
			sampSendChat("/a Желающим отписать:" .. u8:decode(cfg.config.ad))
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 2 then
			sampSendChat("/a Свободна должность - ГА по Жалобам. ЗП - 300р")
			wait(750)
			sampSendChat("/a Критерии: 16 lvl, онлайн 5+, проверять жалобы в группе.")
			wait(750)
			sampSendChat("/a Желающим отписать: @homkarp - Обсуждения!")	
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 3 then
			sampSendChat("/a Свободна должность = ГА по Лидерам. ЗП - 300р")
			wait(750)
			sampSendChat("/a Критерии: 16 lvl adm, онлайн 5+, следить за /leaders")
			wait(750)
			sampSendChat("/a Желающим отписать: @homkarp - Обсуждения!")
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 4 then
			sampSendChat("/a Свободна должность - Зам.Руководителя")
			wait(750)
			sampSendChat("/a Критерии: 16 lvl, онлайн 6+, следить за ГА,админами,репортами")
			wait(750)
			sampSendChat("/a Желающим отписать: @homkarp - Обсуждения!")	
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 5 then
			sampSendChat("/o В данный момент проходит набор в Пиар-Команду! Для всех желающих!")
			wait(1000)
			sampSendChat("/o Именно ты сможешь получать ежедневно 50-75 рублей!")
			wait(1000)
			sampSendChat("/o Желающим писать мне в ВК - "  .. u8:decode(cfg.config.ad))
			wait(1000)
			sampSendChat("/a Проходит набор в пиар-команду. Желающим писать в вк " .. u8:decode(cfg.config.ad))
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 6 then
			sampSendChat("/aad Привет, на нашем сервере открыт набор Лидеров(/leaders)!")
			wait(1000)
			sampSendChat("/aad Критерии: 5+ часов отыгранных(/mm), военный билет, знания правил!")
			wait(1000)
			sampSendChat("/aad Желающие могут оставить заявку в группе ВК @homkarp - Обсуждения!")
		elseif ad_check.v == true and cfg.interface.ad_radiobutton == 7 then 
			sampSendChat("/o [INFO] Ув.Игроки, если у вас имеется жалоба на читера/лидера/админа...")
			wait(1000)
			sampSendChat("/o [INFO] Вы можете всегда написать её в группу ВК - @homkarp - Обсуждения!")
			wait(700)
			sampSendChat("/a [INFO]Ув.Администрация, если у вас имеется какая-та жалоба...")
			wait(700)
			sampSendChat("/a [INFO] Вы можете всегда написать её в группу ВК @homkarp - Обсуждения!")
		end
    	wait(ad_slider.v*60000)
	end
end

function piar_vr()
	wait(2300)
	while stat['act'] do
		if vr_check.v == true then
			sampSendChat("/reklama")	
			wait(1000)	
			sampSendChat("/a " .. u8:decode(cfg.config.vr))
			wait(1000)	
			sampSendChat("/hc " .. u8:decode(cfg.config.vr))
			wait(1000)
			sampSendChat("/v " .. u8:decode(cfg.config.vr))
		end
    	wait(vr_slider.v*60000)
	end
end

function reloading()
	thisScript():reload()
	sampAddChatMessage("Џерезагрузка!!", 0x5CBCFF)
end
	
function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function cmd_imgui()
	main_window_state.v = not main_window_state.v
    imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
    local style = imgui.GetStyle()
	local clrs = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.Alpha = 1
	style.ChildWindowRounding = 0
	style.WindowRounding = 0
	style.GrabRounding = 0
	style.GrabMinSize = 12
	style.FrameRounding = 5
	if styles == 0 then
		clrs[clr.Text] = ImVec4(1, 1, 1, 1)
		clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
		clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ChildWindowBg] = ImVec4(9.9998999303352e-07, 9.9999613212276e-07, 9.9999999747524e-07, 0)
		clrs[clr.PopupBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.Border] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.BorderShadow] = ImVec4(9.9999999747524e-07, 9.9998999303352e-07, 9.9998999303352e-07, 0)
		clrs[clr.FrameBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.FrameBgHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.FrameBgActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.TitleBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.TitleBgActive] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.TitleBgCollapsed] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.MenuBarBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.ScrollbarBg] = ImVec4(0.14883691072464, 0.14883720874786, 0.14883571863174, 1)
		clrs[clr.ScrollbarGrab] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.ScrollbarGrabHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.ScrollbarGrabActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.ComboBg] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
		clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
		clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
		clrs[clr.Button] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.ButtonHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.ButtonActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.Header] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.HeaderHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.HeaderActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.Separator] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.SeparatorHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.SeparatorActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.ResizeGrip] = ImVec4(0.14117647707462, 0.45098039507866, 0.82352942228317, 1)
		clrs[clr.ResizeGripHovered] = ImVec4(0.062745101749897, 0.37254902720451, 0.74509805440903, 1)
		clrs[clr.ResizeGripActive] = ImVec4(0.10196078568697, 0.41176471114159, 0.7843137383461, 1)
		clrs[clr.CloseButton] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 0.88235294818878)
		clrs[clr.CloseButtonHovered] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 1)
		clrs[clr.CloseButtonActive] = ImVec4(0.19607843458652, 0.19607843458652, 0.19607843458652, 0.60784316062927)
		clrs[clr.PlotLines] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
		clrs[clr.PlotLinesHovered] = ImVec4(1, 0.99999779462814, 0.99998998641968, 1)
		clrs[clr.PlotHistogram] = ImVec4(1, 0.99999779462814, 0.99998998641968, 1)
		clrs[clr.PlotHistogramHovered] = ImVec4(1, 0.9999960064888, 0.99998998641968, 1)
		clrs[clr.TextSelectedBg] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 0.34999999403954)
		clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
	elseif styles == 1 then
		clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
		clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
		clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
		clrs[clr.PopupBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.Border] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.BorderShadow] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.FrameBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
		clrs[clr.FrameBgHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.58823531866074)
		clrs[clr.FrameBgActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.39215686917305)
		clrs[clr.TitleBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.82352942228317)
		clrs[clr.TitleBgActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.TitleBgCollapsed] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.66666668653488)
		clrs[clr.MenuBarBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ScrollbarGrab] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.ScrollbarGrabHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
		clrs[clr.ScrollbarGrabActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.58823531866074)
		clrs[clr.ComboBg] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
		clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
		clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
		clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
		clrs[clr.Button] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.ButtonHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
		clrs[clr.ButtonActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
		clrs[clr.Header] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.HeaderHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
		clrs[clr.HeaderActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
		clrs[clr.Separator] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.SeparatorHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.SeparatorActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.ResizeGrip] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.ResizeGripHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.7843137383461)
		clrs[clr.ResizeGripActive] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 0.70588237047195)
		clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
		clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
		clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
		clrs[clr.PlotLines] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.PlotLinesHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.PlotHistogram] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.PlotHistogramHovered] = ImVec4(0.52941179275513, 0.70588237047195, 0.011764706112444, 1)
		clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
		clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
	elseif styles == 2 then
		clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
		clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
		clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
		clrs[clr.PopupBg] = ImVec4(0.70588237047195, 0.011764694936574, 0.37980872392654, 1)
		clrs[clr.Border] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.BorderShadow] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.FrameBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
		clrs[clr.FrameBgHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.58823531866074)
		clrs[clr.FrameBgActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.39215686917305)
		clrs[clr.TitleBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.82352942228317)
		clrs[clr.TitleBgActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.TitleBgCollapsed] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.66666668653488)
		clrs[clr.MenuBarBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ScrollbarGrab] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.ScrollbarGrabHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
		clrs[clr.ScrollbarGrabActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.58823531866074)
		clrs[clr.ComboBg] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
		clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
		clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
		clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
		clrs[clr.Button] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.ButtonHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
		clrs[clr.ButtonActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
		clrs[clr.Header] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.HeaderHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
		clrs[clr.HeaderActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
		clrs[clr.Separator] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.SeparatorHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.SeparatorActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.ResizeGrip] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.ResizeGripHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.7843137383461)
		clrs[clr.ResizeGripActive] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 0.70588237047195)
		clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
		clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
		clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
		clrs[clr.PlotLines] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.PlotLinesHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.PlotHistogram] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.PlotHistogramHovered] = ImVec4(0.70588237047195, 0.011764706112444, 0.38039216399193, 1)
		clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
		clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
	elseif styles == 3 then
		clrs[clr.Text] = ImVec4(1, 0.99998998641968, 0.99998998641968, 1)
		clrs[clr.TextDisabled] = ImVec4(0.60000002384186, 0.60000002384186, 0.60000002384186, 1)
		clrs[clr.WindowBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ChildWindowBg] = ImVec4(0, 0, 0, 0)
		clrs[clr.PopupBg] = ImVec4(0.85116279125214, 0.59383445978165, 0, 1)
		clrs[clr.Border] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.BorderShadow] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.FrameBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
		clrs[clr.FrameBgHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.58823531866074)
		clrs[clr.FrameBgActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.39215686917305)
		clrs[clr.TitleBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.82352942228317)
		clrs[clr.TitleBgActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.TitleBgCollapsed] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.66666668653488)
		clrs[clr.MenuBarBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.ScrollbarBg] = ImVec4(0, 0, 0, 1)
		clrs[clr.ScrollbarGrab] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.ScrollbarGrabHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
		clrs[clr.ScrollbarGrabActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.58823531866074)
		clrs[clr.ComboBg] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
		clrs[clr.CheckMark] = ImVec4(1, 1, 1, 1)
		clrs[clr.SliderGrab] = ImVec4(0.1803921610117, 0.1803921610117, 0.1803921610117, 1)
		clrs[clr.SliderGrabActive] = ImVec4(0.258823543787, 0.258823543787, 0.258823543787, 1)
		clrs[clr.Button] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.ButtonHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
		clrs[clr.ButtonActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
		clrs[clr.Header] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.HeaderHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
		clrs[clr.HeaderActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
		clrs[clr.Separator] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.SeparatorHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.SeparatorActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.ResizeGrip] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.ResizeGripHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.7843137383461)
		clrs[clr.ResizeGripActive] = ImVec4(0.85490196943283, 0.59215688705444, 0, 0.70588237047195)
		clrs[clr.CloseButton] = ImVec4(9.9998999303352e-07, 9.9998999303352e-07, 9.9999999747524e-07, 1)
		clrs[clr.CloseButtonHovered] = ImVec4(0.29019609093666, 0.29019609093666, 0.29019609093666, 1)
		clrs[clr.CloseButtonActive] = ImVec4(0.77209305763245, 0.77208530902863, 0.77208530902863, 0.7843137383461)
		clrs[clr.PlotLines] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.PlotLinesHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.PlotHistogram] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.PlotHistogramHovered] = ImVec4(0.85490196943283, 0.59215688705444, 0, 1)
		clrs[clr.TextSelectedBg] = ImVec4(0.25581139326096, 0.25581139326096, 0.25581395626068, 0.34999999403954)
		clrs[clr.ModalWindowDarkening] = ImVec4(0.20000000298023, 0.20000000298023, 0.20000000298023, 0.34999999403954)
	elseif styles == 4 then
	
	end
	
	local styles = {u8"Синий стиль", u8"Зеленый стиль", u8"Розовый стиль", u8"Оранджевый стиль", u8"прозрачный стиль"}

	if not main_window_state.v then
        imgui.Process = false
    end

    if main_window_state.v then
    	local sw, sh = getScreenResolution()

        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600, 475), imgui.Cond.FirstUseEver)
        imgui.Begin(u8"Auto Seller", main_window_state, imgui.WindowFlags.NoResize)
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("поиск покупашек")).x)/2)
        imgui.Text(u8"поиск покупашек")
        if imgui.Checkbox("##1Текст", vr_check) then
        	cfg.interface.vr_checkbox = vr_check.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.SameLine(30)
        imgui.PushItemWidth(560)
        if imgui.InputText("##2", vr) then
			cfg.config.vr = vr.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.PushItemWidth(582)
        if imgui.SliderInt("##3", vr_slider, 1, 10, u8'%.0f мин') then
        	cfg.interface.vr_slider = vr_slider.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
		imgui.Separator()
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Уведомлять аддминов о репорте")).x)/2) 
		imgui.Text(u8"уведомлять админов о репорте")
        if imgui.Checkbox("##4", fam_check) then
        	cfg.interface.fam_checkbox = fam_check.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.SameLine(30)
        imgui.PushItemWidth(582)
        if imgui.SliderInt("##6", fam_slider, 1, 10, u8'каждые(ую) %.0f мин') then
        	cfg.interface.fam_slider = fam_slider.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.Separator()
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Пиар в свою семью")).x)/2)
        imgui.Text(u8"пиарить свою семью")
        if imgui.Checkbox("##7", j_check) then
        	cfg.interface.j_checkbox = j_check.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.SameLine(30)
        imgui.PushItemWidth(560)
        if imgui.InputText("##8", j) then
			cfg.config.j = j.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.PushItemWidth(582)
        if imgui.SliderInt("##9", j_slider, 1, 10, u8'%.0f мин') then
        	cfg.interface.j_slider = j_slider.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.Separator()
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Пиар промокода")).x)/2)
        imgui.Text(u8"Пиар промокода")
        if imgui.Checkbox("##10", s_check) then
        	cfg.interface.s_checkbox = s_check.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.SameLine(30)
        imgui.PushItemWidth(120)
        if imgui.InputText("#promo", s) then
			cfg.config.s = s.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.PushItemWidth(582)
        if imgui.SliderInt("##12", s_slider, 1, 10, u8'%.0f мин') then
        	cfg.interface.s_slider = s_slider.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.Separator()
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Поиск ГА (Укажите ваш вк ниже без vk.com)")).x)/2)
		imgui.Text(u8"Поиск ГА (Укажите ваш вк ниже без vk.com)")
		imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'(!)', imgui.SameLine())
        if imgui.Checkbox("##13", ad_check) then
        	cfg.interface.ad_checkbox = ad_check.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.SameLine(0)
        imgui.PushItemWidth(150)
        if imgui.InputText("##14", ad) then
			cfg.config.ad = ad.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
        imgui.PushItemWidth(560)
        if imgui.SliderInt("##15", ad_slider, 1, 10, u8'%.0f мин') then
        	cfg.interface.ad_slider = ad_slider.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Цветовая тема окна")).x)/2) 
		imgui.Text(u8"Выберите категорию")
		imgui.TextColored(imgui.ImVec4(1.0, 0.0, 0.0, 1.0 ), u8'(!)', imgui.SameLine())	
		if imgui.RadioButton(u8"Поиск ГА ПО АДМ", ad_radiobutton, 1) then
			cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для поиска га по адм")
		if imgui.RadioButton(u8"Поиск ГА ПО ЖБ", ad_radiobutton, 2) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для поиска га по жб")
		if imgui.RadioButton(u8"Поиск ГА ПО ЛИД", ad_radiobutton, 3) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для поиска га по лидерам")
		if imgui.RadioButton(u8"Поиск Зам.Рук", ad_radiobutton, 4) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для поиска замистителя руководителя!")
		if imgui.RadioButton(u8"Поиск Пиарщиков", ad_radiobutton, 5) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для уведомления о наборе в пиар-команду")
		if imgui.RadioButton(u8"Поиск Лидеров", ad_radiobutton, 6) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для уведомления о наборе лидеров в /aad")
		if imgui.RadioButton(u8"Уведомление о Жалоб", ad_radiobutton, 7) then
        	cfg.interface.ad_radiobutton = ad_radiobutton.v
            inicfg.save(cfg, "AutoSeller.ini")
        end imgui.SameLine() imgui.HelpMarker(u8"Используется для уведомления игроков о жалобах!")
		imgui.Separator()
        imgui.SameLine()
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Информация о скрипте")).x)/2)
		imgui.Text(u8"Информация о скрипте")
		imgui.Text(u8"Автор: Fill_Angels")
		imgui.Text(u8"Cвязь с автором: vk.com/homkarp993")
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Скрипт был сделан для проекта Way of Life!")).x)/2)
		imgui.Text(u8"Скрипт был сделан для проекта Way of Life!")
		imgui.Separator() 
        imgui.SameLine(470)
		imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(u8("Цветовая тема окна")).x)/2)
        imgui.Text(u8"Цветовая тема окна")
        if imgui.Combo("##16", themes_combo, styles) then
        	styles = themes_combo.v
        	cfg.interface.theme_id = themes_combo.v
            inicfg.save(cfg, "AutoSeller.ini")
        end
		imgui.Separator()
		if imgui.Button(u8((stat['act'] and 'Остановить' or 'Запустить')..''), imgui.ImVec2(582, 20)) then
        	stat['act'] = not stat['act']
        	if stat['act'] then
				piar_vr1 = lua_thread.create(piar_vr)
				piar_fam2 = lua_thread.create(piar_fam)
				piar_j3 = lua_thread.create(piar_j)
				piar_s4 = lua_thread.create(piar_s)
				piar_ad5 = lua_thread.create(piar_ad)
			else
				if piar_vr1 then piar_vr1:terminate() end
				if piar_fam2 then piar_fam2:terminate() end
				if piar_j3 then piar_j3:terminate() end
				if piar_s4 then piar_s4:terminate() end
				if piar_ad5 then piar_ad5:terminate() end
			end
			if vr_check.v == false and fam_check.v == false and j_check.v == false and ad_check.v == false and s_check.v == false then
				sampAddChatMessage("[AutoSeller]: {FFFFFF}Небыло выбрано ниодного варианта пиара!", 0x5CBCFF)
				stat['act'] = false
			else
				sampAddChatMessage(stat['act'] and "[AutoSeller]: {FFFFFF}скрипт активирован!" or "[AutoSeller]: {FFFFFF}скрипт деактивирован!", 0x5CBCFF)
			end	
		end
		imgui.End()
    end
end

function ev.onSendCommand(cmd)
	local result = cmd:match('^/a (.+)')
	if result ~= nil then 
		process, finished = nil, false
		message = tostring(result)
		process = lua_thread.create(function()
			while not finished do
				if sampGetGamestate() ~= 3 or not sampIsLocalPlayerSpawned() then
					finished = true; break
				end
		        wait(0)
			end
		end)
	end
end

function ev.onServerMessage(color, text)
	if text:find('^%[Ошибка%].*После последнего сообщения в этом чате нужно подождать') then
		lua_thread.create(function()
			wait(delay * 1000);
			sampSendChat('/a ' .. message)
		end)
		return false
	end
end