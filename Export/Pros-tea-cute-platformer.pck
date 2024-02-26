GDPC                �                                                                         X   res://.godot/exported/133200997/export-81c2a9fb1e93a74ea50fa2901980b7b5-test_world.scn   )      m      HW�����Y���i��    T   res://.godot/exported/133200997/export-8217d0630bacc334c62d6dbf7adbbbe6-player.scn  �      �      C�H/ν���(G�q    T   res://.godot/exported/133200997/export-d5d465d1e210c65468e24ba76399dafa-block.scn   �$            e3��@Ŋ���(1�T    ,   res://.godot/global_script_class_cache.cfg  p>      �      �̑�>z���_+��L    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctexp/      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  �E      �       v�3���6�eN���    (   res://Entities/Player/PlayerCamera.gd   P"      �      �9\�&���Z��    8   res://Entities/Player/State Machine/PlayerIdleState.gd          �      H&4G0�'*�b���    8   res://Entities/Player/State Machine/PlayerJumpState.gd  �      �      �l��Q�X��6;�%p�    8   res://Entities/Player/State Machine/PlayerRunState.gd   �	      �      ��7촜��&@�L s    4   res://Entities/Player/State Machine/PlayerState.gd  0      �       �%Xx��M�Ob�䴧��    4   res://Entities/Player/State Machine/StateMachine.gd �      �      �f��8����HT���g        res://Entities/Player/player.gd �      �      .�%?��v#�g��=G    (   res://Entities/Player/player.tscn.remap  =      c       p�d�#�`��V64U    $   res://Level/Props/block.tscn.remap  �=      b       ȸ`�6����]�7��    $   res://Level/test_world.tscn.remap    >      g       Fz��;��v�z�       res://icon.svg  B      �      C��=U���^Qu��U3       res://icon.svg.import   P<      �       ���R"^L�<��n�       res://project.binarypF      �      �#o�F��]� �    �Y��class_name PlayerIdleState
extends PlayerState

# Reference to the relevant nodes that need to work when the player is in this state
@export var actor: Player					# Pass the player's CharacterBody2D
@export var animator: AnimatedSprite2D		# Pass the player's AnimatedSprite2D

# Signals this state will emit to let the state machine know when to switch to another state
signal pressed_left_or_right
signal pressed_jump

# Add anything that needs to be done when loaded
func _ready():
	pass

# Add stuff to do when player enters this state
func _enter_state() -> void:
	set_physics_process(true)	# turn on physics when player enters this state

# Add stuff to do when player leaves this state
func _exit_state() -> void:
	set_physics_process(false) # turn off physics when changing states to save memory

# Place conditions on when to emit the signals as well as general stuff that needs to happen
func _process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		pressed_jump.emit()
	
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		pressed_left_or_right.emit()
	
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
�'��6�V�class_name PlayerJumpState
extends PlayerState

# Reference to the relevant nodes that need to work when the player is in this state
@export var actor: Player					# Pass the player's CharacterBody2D
@export var animator: AnimatedSprite2D		# Pass the player's AnimatedSprite2D
var land_watcher = 1

# Signals this state will emit to let the state machine know when to switch to another state
signal falling
signal landed

# Add anything that needs to be done when loaded
func _ready():
	pass

# Add stuff to do when player enters this state
func _enter_state() -> void:
	land_watcher = 0
	set_physics_process(true)	# turn on physics when player enters this state
	actor.velocity.y -= actor.jump_velocity

# Add stuff to do when player leaves this state
func _exit_state() -> void:
	set_physics_process(false) # turn off physics when changing states to save memory

# Place conditions on when to emit the signals as well as general stuff that needs to happen
func _process(delta):
	
	#if actor.velocity.y > 0:
	#	falling.emit()
	
	if actor.is_on_floor() and land_watcher == 0:
		landed.emit()
		land_watcher += 1
	
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()
f%��Gclass_name PlayerRunState
extends PlayerState

# Reference to the relevant nodes that need to work when the player is in this state
@export var actor: Player					# Pass the player's CharacterBody2D
@export var animator: AnimatedSprite2D		# Pass the player's AnimatedSprite2D

# Signals this state will emit to let the state machine know when to switch to another state
signal released_left_or_right
signal pressed_jump

# Add anything that needs to be done when loaded
func _ready():
	pass

# Add stuff to do when player enters this state
func _enter_state() -> void:
	set_physics_process(true)	# turn on physics when player enters this state

# Add stuff to do when player leaves this state
func _exit_state() -> void:
	set_physics_process(false) # turn off physics when changing states to save memory

# Place conditions on when to emit the signals as well as general stuff that needs to happen
func _process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		pressed_jump.emit()
	
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		released_left_or_right.emit()
	
	if actor.is_on_wall_only() and Input.is_action_just_pressed("left") and actor.last_button == "right":
		actor.last_button = "left"
		actor.velocity.y = 0
		actor.velocity.x -= actor.jump_velocity
		actor.velocity.y -= actor.jump_velocity
	if actor.is_on_wall_only() and Input.is_action_just_pressed("right") and actor.last_button == "left":
		actor.last_button = "right"
		actor.velocity.y = 0
		actor.velocity.x += actor.jump_velocity
		actor.velocity.y -= actor.jump_velocity
	
	# Get the input direction and handle the movement.
	var direction = Input.get_axis("left", "right")
	if direction:
		actor.velocity.x += direction * actor.acceleration
	else:
		actor.velocity.x += 0
	
	# Slow down horizontal movement (friction)
	if actor.velocity.x > 10:
		actor.velocity.x -= 20
	elif actor.velocity.x < -10:
		actor.velocity.x += 20
	else:
		actor.velocity.x = 0
	
	# Cap the max speed
	if actor.velocity.x > actor.max_speed:
		actor.velocity.x = actor.max_speed
	if actor.velocity.x < actor.max_speed * -1:
		actor.velocity.x = actor.max_speed * -1
	
	actor.move_and_slide()
��_# State superclass that all player states inherit from
class_name PlayerState
extends Node

signal state_finished

func _enter_state() -> void:
	pass
	
func _exit_state() -> void:
	pass
᳤��# Finite State Machine Class that handles state changing
class_name FiniteState
extends Node

# Make sure to pass a default state in the inspector
@export var state: PlayerState

# When ready, enter default state
func _ready():
	change_state(state)

# Function that handles state switching
func change_state(new_state: PlayerState):
	if state is PlayerState:
		state._exit_state()
	new_state._enter_state()
	state = new_state
�xg�~class_name Player
extends CharacterBody2D

@export var max_speed = 80.0
@export var acceleration = 50.0
@export var jump_velocity = 200.0
var last_button = ""

# declare state machine and every state this entity has
@onready var state_machine = $StateMachine as FiniteState
@onready var idle_state = $StateMachine/Idle as PlayerIdleState
@onready var run_state = $StateMachine/Run as PlayerRunState
@onready var jump_state = $StateMachine/Jump as PlayerJumpState

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Link all the states and their signals
	idle_state.pressed_left_or_right.connect(state_machine.change_state.bind(run_state))
	idle_state.pressed_jump.connect(state_machine.change_state.bind(jump_state))
	run_state.released_left_or_right.connect(state_machine.change_state.bind(idle_state))
	run_state.pressed_jump.connect(state_machine.change_state.bind(jump_state))
	jump_state.landed.connect(state_machine.change_state.bind(idle_state))

func _physics_process(delta):
	if Input.is_action_just_pressed("left") and !is_on_wall():
		last_button = "left"
	if Input.is_action_just_pressed("right") and !is_on_wall():
		last_button = "right"
	
	if is_on_wall() and velocity.y > 100 or Input.is_action_pressed("jump") and velocity.y > 0:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/4
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
X�XRSRC                    PackedScene            ��������                                                  ..    Idle    resource_local_to_scene    resource_name 	   _bundled    script       Script     res://Entities/Player/player.gd ��������
   Texture2D    res://icon.svg N����+   Script &   res://Entities/Player/PlayerCamera.gd ��������   Script 4   res://Entities/Player/State Machine/StateMachine.gd ��������   Script 7   res://Entities/Player/State Machine/PlayerIdleState.gd ��������   Script 6   res://Entities/Player/State Machine/PlayerRunState.gd ��������   Script 7   res://Entities/Player/State Machine/PlayerJumpState.gd ��������      local://PackedScene_jfq0n �         PackedScene          	         names "         Player    script 
   max_speed    jump_velocity    CharacterBody2D 	   Sprite2D 	   modulate 	   position    texture    CollisionShape2D    visible    scale    polygon    CollisionPolygon2D 	   Camera2D    actor    follow_speed    StateMachine    state    Node    Idle    Run    Jump    	   variants                      zC     �C   ��A?�{?      �?
     �B  �B                
     �B  �B
     �@  �@%      RU�2UU�  @�Ϊ*�  @�  �@   �   A���@   ARUA  �@RUAΪ*�\U�@2UU�                        �>                                                                 node_count             nodes     d   ��������       ����                                        ����                                    	   ����   
                     	                     ����            
     @                           ����           @                    ����           @                    ����           @                    ����           @             conn_count              conns               node_paths              editable_instances              version             RSRC�x쒔�����extends Camera2D

@export var actor: Player
@export var follow_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x > actor.global_position.x+10:
		global_position.x -= follow_speed
	if global_position.x < actor.global_position.x-10:
		global_position.x += follow_speed
	if global_position.y > actor.global_position.y+10:
		global_position.y -= follow_speed
	if global_position.y < actor.global_position.y-10:
		global_position.y += follow_speed
�Cpl��9/vy��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    size    script    custom_solver_bias 	   _bundled        #   local://PlaceholderTexture2D_qsumx Z         local://RectangleShape2D_lu207 �         local://PackedScene_4n2au �         PlaceholderTexture2D       
      C   C         RectangleShape2D             PackedScene          	         names "   
      Block    StaticBody2D 	   Sprite2D 	   modulate 	   position    texture    CollisionShape2D    visible    scale    shape    	   variants                        �?
     �B  �B                 
     �@  �@               node_count             nodes     #   ��������       ����                      ����                                        ����                     	                conn_count              conns               node_paths              editable_instances              version             RSRC��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       PackedScene    res://Level/Props/block.tscn ,��U��N]   PackedScene "   res://Entities/Player/player.tscn h���      local://PackedScene_25yge W         PackedScene          	         names "         test_world    scale    metadata/_edit_lock_    Node2D    Props    Node    Block 	   position    Block3    Block12    Block6    Block2    Block7    Block8    Block13    Block4    Block5    Player    	   variants       
     �?@O?                
          D
      A@O?
     �?  �@
     �D  �C
     �?ff@
     @D    
     �?  @@
     �D  �C
     �@  �?
     0E   �
   #�y?  �@
     E  �C
     �?t{?@
     �D  �C
     �?   @
     �D   D
     @@  �?
     E  �C         
     D!�PC      node_count             nodes     �   ��������       ����                                  ����               ���                                ���                          ���	                                ���
                  	              ���            
                    ���                                ���                                ���                                ���                                ���                                 ���                         conn_count              conns               node_paths              editable_instances              version             RSRC��GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ ��:p��iOf��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bkyttbjegv8lm"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 ���0�XHm�'���[remap]

path="res://.godot/exported/133200997/export-8217d0630bacc334c62d6dbf7adbbbe6-player.scn"
��S6��+"4��[remap]

path="res://.godot/exported/133200997/export-d5d465d1e210c65468e24ba76399dafa-block.scn"
Q�u��eIga��@u[remap]

path="res://.godot/exported/133200997/export-81c2a9fb1e93a74ea50fa2901980b7b5-test_world.scn"
UI΢x~rclist=Array[Dictionary]([{
"base": &"Node",
"class": &"FiniteState",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/State Machine/StateMachine.gd"
}, {
"base": &"CharacterBody2D",
"class": &"Player",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/player.gd"
}, {
"base": &"PlayerState",
"class": &"PlayerIdleState",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/State Machine/PlayerIdleState.gd"
}, {
"base": &"PlayerState",
"class": &"PlayerJumpState",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/State Machine/PlayerJumpState.gd"
}, {
"base": &"PlayerState",
"class": &"PlayerRunState",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/State Machine/PlayerRunState.gd"
}, {
"base": &"Node",
"class": &"PlayerState",
"icon": "",
"language": &"GDScript",
"path": "res://Entities/Player/State Machine/PlayerState.gd"
}])
M�<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
�a |4d��K   h���!   res://Entities/Player/player.tscn,��U��N]   res://Level/Props/block.tscn�m�O��&   res://Level/test_world.tscnN����+   res://icon.svg�8=2�ECFG
      application/config/name,      "   Pros-tea-cute-institute-platformer     application/run/main_scene$         res://Level/test_world.tscn    application/config/features   "         4.1    Mobile     application/config/icon         res://icon.svg  "   display/window/size/viewport_width         #   display/window/size/viewport_height      �  
   input/left4              deadzone      ?      events                  InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/right0              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      
   input/jump�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode       	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script      #   rendering/renderer/rendering_method         mobile  �[-~��6+$�