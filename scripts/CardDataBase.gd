const CARDS = {			 #type,	price,+money, +health,
	"ANGUSTIAS_PER": 	["nieto",	1,	1,	-1],
	"ENRIQUETA_PER":	["nieto",	0,	1,	-1],
	"GERTRUDIS_PER":	["planta",	0,	1,	1],
	"GREGORIO_PER":		["planta",	0,	1,	1],
	"JEREMIAS_PER":		["planta",	0,	1,	1],
	"LIBERTO_PER":		["mascota",	0,	1,	0],
	"URSULA_PER":		["mascota",	0,	1,	0],
	
	"DENTADURA_POSTIZA":	["spell", 1, 0, 1],
	"BOINA":			["spell", 1, 0, 1],
	"TACATACA":			["spell", 1, 0, 1],
	"PARTIDA_DE_PETANCA":	["spell", 1, 0, 1],
	"AUDIFONO":			["spell", 1, 0, 1],
	"SIESTA":			["spell", 0, 0, 1],
	"CONTAR_BATALLITAS":	["spell", 0, 0, 1],
	"PASEO_POKEMON_GO":	["spell", 0, 0, 1],
	"GOLISMEAR":		["spell", 0, 0, 1],
	"DESCUBRIR_TELENOVELA":["spell", 0, 0, 1],
	
	"DULCES":			["spell", 1, 0, -1],
	"CLASE_DE_ZUMBA":		["spell", 1, 0, -1],
	"FUMAR_A_ESCONDIDAS":	["spell", 1, 0, -1],
	"VER_LAS_NOTICIAS":	["spell", 0, 0, -1],
	"RECUERDO_DE_LA_GUERRA":["spell", 0, 0, -1],
	"PERDERSE_EN_EL_SUPER":	["spell", 0, 0, -1],
	
	"MARCAPASOS":	["spell", 2, 0, 2],
	"PROTESIS_DE_CADERA":	["spell", 2, 0, 2],
	"EXOESQUELETO":	["spell", 2, 0, 2],
	"SILLA_DE_RUEDAS":	["spell", 2, 0, 2],
	"CRUCERO":	["spell", 2, 0, 2],
	
	"AUTOMEDICACION":	["spell", 2, 0, -2],
	"MOVIL_4G":	["spell", 2, 0, -2],
	"PAGAR_TU_FUNERAL":	["spell", 2, 0, -2],
	
	"MONEDA_EN_CABINA":	["spell", 0, 1, 0],
	"DINERO_EN_PANTALON_VIEJO":	["spell", 0, 1, 0],
	"HUCHA_DEL_CERDITO":	["spell", 0, 1, 0],
	"MIRAR_DETRAS_DEL_SOFA":	["spell", 0, 1, 0],
	"VENDER_ACCIONES":	["spell", 0, 1, 0],
	"VENDER_ANTIGUEDAD":	["spell", 0, 1, 0],
	
	"AGUJERO_EN_EL_PANTALON":	["spell", 0, -1, 0],
	"LIMOSNA":	["spell", 0, -1, 0],
	"HIPOTECA_DE_LOS_HIJOS":	["spell", 0, -1, 0],
	"ESTRENAS_DE_NAVIDAD":	["spell", 0, -1, 0],
	"DIENTE_DE_ORO":	["spell", 0, -1, 0],
	"SEGURO_PRIVADO":	["spell", 0, -1, 0],
	
	"PISO_DE_ESTUDIANTES":	["propiedad", 0, 0, 0],
	"CASA_EN_LA_PLAYA":	["propiedad", 0, 0, 0],
	"TIERRAS_DE_CULTIVO":	["propiedad", 0, 0, 0],
	"CASA_DE_PUEBLO":	["propiedad", 0, 0, 0],
	"CABANYA_EN_EL_MONTE":	["propiedad", 0, 0, 0],
	"LUXUS_CARAVAN":	["propiedad", 0, 0, 0],
	
	"MUERTE_AL_NIETO":	["special", 0, 0, 0],
	"ELIMINA_UN_NIETO":	["special", 0, 0, 0],
	
	"BABY_SITTER":	["special", 2, 0, 0], #transfiere nietos a otro jugador
	
	"NIETO_FAMOSO":	["nieto", 0, 1, 3],
	"NIETO_YOUTUBER":	["nieto", 0, 1, 3],
	"NIETO_NORMAL":	["nieto", 0, 1, -1],
	"NIETO_MEH":	["nieto", 0, 1, -1],
	"NIETO_COMUN":	["nieto", 0, 1, -1],
	"NIETO_AVIPAO":	["nieto", 0, 1, 0],
	"NIETO_AUSTERO":	["nieto", 0, 1, 0],
	"NIETO_VEGETARIANO":	["nieto", 0, 1, 0], #proteccion contra plantas
	"NIETO_DERROCHADOR":	["nieto", 0, 1, -2],
	"NIETO_PIJO":	["nieto", 0, 1, -2],
	
	"MUERTE_AL_GATO":	["special", 0, 0, 0],
	"MUERTE_AL_PERRO":	["special", 0, 0, 0],
	
	"PASEADOR_DE_PERROS": ["special", 0 ,0 ,0], #transfiere mascotas a otro jugador
	
	"MASCOTA_COCODRILO":	["mascota", 0, -1, -2], #protección contra nietos
	"MASCOTA_BOA_CONSTRICTOR":	["mascota", 0, -1, -2], #protección contra nietos
	"MASCOTA_OCA":	["mascota", 0, 1, -2],
	"ACUARIO":	["mascota", 0, 1, -1],
	"NIETO_FURRY":	["mascota", 0, 1, -1],
	"MASCOTA_PERRO":	["mascota", 0, 1, 0],
	"MASCOTA_GATO":	["mascota", 0, 1, 0],
	"MASCOTA_HAMSTER":	["mascota", 0, 1, 0],
	"MASCOTA_BUHO":	["mascota", 0, 1, 0],
	"MASCOTA_TORTUGA":	["mascota", 0, 1, 0],
	
	"MUERTE_A_LA_HIERBA":	["special", 0, 0, 0],
	"MUERTE_A_LA_HUERTA":	["special", 0, 0, 0],
	
	"ABUELO_EN_LA_JUNGLA":	["special", 0, 0, 0], #transfiere plantas a otro jugador
	
	"PLANTA_PINO":	["planta", 0, 1, 0],
	"PLANTA_TULIPAN":	["planta", 0, 1, 0],
	"PLANTA_SAUCE_LLORON":	["planta", 0, 1, 0],
	"PLANTA_MARGARITA":	["planta", 0, 1, 0],
	"PLANTA_FLOR_DE_PLASTICO":	["planta", 0, 1, 0],
	"PLANTA_CARNIVORA":	["planta", 0, 1, 0], #proteccion contra mascotas
}

const FULL_DECK = [
	"DENTADURA_POSTIZA",
	"BOINA",
	"TACATACA",
	"PARTIDA_DE_PETANCA",
	"AUDIFONO",
	"SIESTA",
	"CONTAR_BATALLITAS",
	"PASEO_POKEMON_GO",
	"GOLISMEAR",
	"DESCUBRIR_TELENOVELA",
	
	"DULCES",
	"CLASE_DE_ZUMBA",
	"FUMAR_A_ESCONDIDAS",
	"VER_LAS_NOTICIAS",
	"RECUERDO_DE_LA_GUERRA",
	"PERDERSE_EN_EL_SUPER",
	
	"MARCAPASOS",
	"PROTESIS_DE_CADERA",
	"EXOESQUELETO",
	"SILLA_DE_RUEDAS",
	"CRUCERO",
	
	"AUTOMEDICACION",
	"MOVIL_4G",
	"PAGAR_TU_FUNERAL",
	
	"MONEDA_EN_CABINA",
	"DINERO_EN_PANTALON_VIEJO",
	"HUCHA_DEL_CERDITO",
	"MIRAR_DETRAS_DEL_SOFA",
	"VENDER_ACCIONES",
	"VENDER_ANTIGUEDAD",
	
	"AGUJERO_EN_EL_PANTALON",
	"LIMOSNA",
	"HIPOTECA_DE_LOS_HIJOS",
	"ESTRENAS_DE_NAVIDAD",
	"DIENTE_DE_ORO",
	"SEGURO_PRIVADO",
	
	"PISO_DE_ESTUDIANTES",
	"CASA_EN_LA_PLAYA",
	"TIERRAS_DE_CULTIVO",
	"CASA_DE_PUEBLO",
	"CABANYA_EN_EL_MONTE",
	"LUXUS_CARAVAN",
	
	"MUERTE_AL_NIETO",
	"ELIMINA_UN_NIETO",
	
	"BABY_SITTER", #transfiere nietos a otro jugador
	
	"NIETO_FAMOSO",
	"NIETO_YOUTUBER",
	"NIETO_NORMAL",
	"NIETO_MEH",
	"NIETO_COMUN",
	"NIETO_AVIPAO",
	"NIETO_AUSTERO",
	"NIETO_VEGETARIANO", #proteccion contra plantas
	"NIETO_DERROCHADOR",
	"NIETO_PIJO",
	
	"MUERTE_AL_GATO",
	"MUERTE_AL_PERRO",
	
	"PASEADOR_DE_PERROS", #transfiere mascotas a otro jugador
	
	"MASCOTA_COCODRILO", #protección contra nietos
	"MASCOTA_BOA_CONSTRICTOR", #protección contra nietos
	"MASCOTA_OCA",
	"ACUARIO",
	"NIETO_FURRY",
	"MASCOTA_PERRO",
	"MASCOTA_GATO",
	"MASCOTA_HAMSTER",
	"MASCOTA_BUHO",
	"MASCOTA_TORTUGA",
	
	"MUERTE_A_LA_HIERBA",
	"MUERTE_A_LA_HUERTA",
	
	"ABUELO_EN_LA_JUNGLA", #transfiere plantas a otro jugador
	
	"PLANTA_PINO",
	"PLANTA_TULIPAN",
	"PLANTA_SAUCE_LLORON",
	"PLANTA_MARGARITA",
	"PLANTA_FLOR_DE_PLASTICO",
	"PLANTA_CARNIVORA" #proteccion contra mascotas
	]
