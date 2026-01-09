class ZCL_ZIL_OV_DPC_EXT definition
  public
  inheriting from ZCL_ZIL_OV_DPC
  create public .

public section.
protected section.

  methods CHECK_SUBSCRIPTION_AUTHORITY
    redefinition .
  methods MENSAGEMSET_CREATE_ENTITY
    redefinition .
  methods MENSAGEMSET_DELETE_ENTITY
    redefinition .
  methods MENSAGEMSET_GET_ENTITY
    redefinition .
  methods MENSAGEMSET_GET_ENTITYSET
    redefinition .
  methods MENSAGEMSET_UPDATE_ENTITY
    redefinition .
  methods OVCABSET_CREATE_ENTITY
    redefinition .
  methods OVCABSET_DELETE_ENTITY
    redefinition .
  methods OVCABSET_GET_ENTITY
    redefinition .
  methods OVCABSET_GET_ENTITYSET
    redefinition .
  methods OVCABSET_UPDATE_ENTITY
    redefinition .
  methods OVITEMSET_CREATE_ENTITY
    redefinition .
  methods OVITEMSET_DELETE_ENTITY
    redefinition .
  methods OVITEMSET_GET_ENTITY
    redefinition .
  methods OVITEMSET_GET_ENTITYSET
    redefinition .
  methods OVITEMSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZIL_OV_DPC_EXT IMPLEMENTATION.


  method CHECK_SUBSCRIPTION_AUTHORITY.
  endmethod.


  method MENSAGEMSET_CREATE_ENTITY.
  endmethod.


  method MENSAGEMSET_DELETE_ENTITY.
  endmethod.


  method MENSAGEMSET_GET_ENTITY.
  endmethod.


  method MENSAGEMSET_GET_ENTITYSET.

  endmethod.


  method MENSAGEMSET_UPDATE_ENTITY.
  endmethod.


  METHOD ovcabset_create_entity.
    DATA: ld_lastid TYPE int4.
    DATA: ls_cab TYPE ziltb_ovcab.

    DATA(lo_msg) = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = er_entity
     ).

    MOVE-CORRESPONDING er_entity TO ls_cab.

    ls_cab-data_criacao    = sy-datum.
    ls_cab-data_hora       = sy-uzeit.
    ls_cab-criacao_usuario = sy-uname.

    SELECT SINGLE MAX( ordemid )
      INTO ld_lastid
      FROM ziltb_ovcab.

    ls_cab-ordemid = ld_lastid + 1.
    INSERT ziltb_ovcab FROM ls_cab.

    IF sy-subrc <> 0.
      lo_msg->add_message_text_only(
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = 'Erro ao inserir a ordem'
      ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
      ENDIF.

      MOVE-CORRESPONDING ls_cab TO er_entity.

      CONVERT
        DATE ls_cab-data_criacao
        TIME ls_cab-data_hora
        INTO TIME STAMP er_entity-datacriacao
        TIME ZONE sy-zonlo.
  ENDMETHOD.


  method OVCABSET_DELETE_ENTITY.
  endmethod.


  method OVCABSET_GET_ENTITY.
    er_entity-ordemid = 1.
    er_entity-criadopor = 'Ian'.
    er_entity-datacriacao = '20260108'.
  endmethod.


  method OVCABSET_GET_ENTITYSET.
  endmethod.


  method OVCABSET_UPDATE_ENTITY.

  endmethod.


  method OVITEMSET_CREATE_ENTITY.
    DATA: ls_item TYPE ZILTB_OVITEM.

    DATA(lo_msg) = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = er_entity
    ).

    MOVE-CORRESPONDING er_entity to ls_item.

    IF er_entity-itemid = 0.

      SELECT SINGLE MAX( itemid )
        INTO er_entity-ordemid
        FROM ZILTB_OVITEM
        WHERE ordemid = er_entity-ordemid.

       er_entity-itemid = er_entity-itemid + 1.
    ENDIF.

    INSERT ZILTB_OVITEM FROM ls_item.

    IF sy-subrc <> 0.
      lo_msg->add_message_text_only(
        EXPORTING
          iv_msg_type = 'E'
          iv_msg_text = 'Erro ao inserir Item'
       ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.

    ENDIF.
  endmethod.


  method OVITEMSET_DELETE_ENTITY.
  endmethod.


  method OVITEMSET_GET_ENTITY.
  endmethod.


  method OVITEMSET_GET_ENTITYSET.

  endmethod.


  method OVITEMSET_UPDATE_ENTITY.
  endmethod.
ENDCLASS.
