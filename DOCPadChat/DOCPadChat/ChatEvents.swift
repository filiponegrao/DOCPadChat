//
//  ChatEvents.swift
//  ChatTemplate
//
//  Created by Filipo Negrao on 26/04/16.
//  Copyright © 2016 Filipo Negrao. All rights reserved.
//

import Foundation

enum Event : String
{
    
    //*******  SERVER *******//
    
    /** Faltou um parametro no comando enviado */
    case command_missing = "command_missing"
    
    /** Parametro passado para o evento foi incorreto */
    case command_incorrect = "command_incorrect"
    
    /** Avisa a ocorrencia de um erro no servidor ou no login */
    case account_error = "account_error"
    
    //*******  CONTAS *******//
    
    /** Mensagem referente a necessidade de ter uma conta
     logada e autenticada no servidor.
     O parametro necessario a enviar é um id de Sessão */
    case account_required = "account_required"
    
    /** Para criar uma nova conta.
     * Parametros: username, email, password, gender, country, city */
    case account_create = "account_create"
    
    /** Conta rejeitada por algum parametro invalido */
    case account_rejected = "account_rejected"
    
    /** Conectar uma conta com o id de uma sessao. Retorna o id caso necessario */
    case account_connect = "account_connect"
    
    /** Conta incorreta */
    case account_incorrect = "account_incorrect"
    
    /** Conta conectad e autenticada */
    case account_connected = "account_connected"
    
    /** Deletar uma conta. Passe o email e a senha */
    case account_delete = "account_delete"
    
    /** Recuperar a senha de uma conta */
    case account_forgot = "account_forgot"
    
    /** Passando um email, e uma senha a aplicacao retorna o id da sessao */
    case account_get = "account_get"
    
    /** Rece as informacoes de sua conta */
    case account_info = "account_info"
    
    
    //*******  SESSIONS *******//
    
    /** Procura uma sessao que conetenha uma determinada string no username */
    case session_search = "session_search"
    
    /** Mensagem recebida como resposta à procura de usuários, retorna */
    case session_result = "session_result"
    
    /** Passando um numero de sessao de um usuario, envie uma solicitacao de amizade*/
    case session_add = "session_add"
    
    /** Uma nova sessao quer conectar-se com voce*/
    case session_invitation = "session_invitation"
    
    /** Envia uma notificacao de que recebeu um devido convite de amizade*/
    case session_received = "session_received"
    
    /** Uma nova conectou-se com voce, */
    case session_new = "session_new"
    
    /** Aceita uma solicitacao de amizade */
    case session_accept = "session_accept"
    
    /** Rejeita uma solicitacao de amizade */
    case session_deny = "session_deny"
    
    case session_denied = "session_denied"
    
    /** Remove uma sessao da sua rede de amizades */
    case session_remove = "session_remove"
    
    /** Notifica que alguem o removeu da sua rede de amizades */
    case session_removed = "session_removed"
    
    /** Muda o nickname */
    case session_nickname = "session_nickname"
    
    /** Uma sessao mudou de nickname */
    case session_changed = "session_changed"
    
    /** Bloqueia uma sessao */
    case session_block = "session_block"
    
    /** Recebe uma notitifacao de que uma secao te bloqueou */
    case session_blocked = "session_blocked"
    
    /** Desbloqueia uma sessao previamente bloqueada */
    case session_unblock = "session_unblock"
    
    /** Recebe uma notificacao de que uma sessao lthe desbloqueou */
    case session_unblocked = "session_ublocked"
    

    //*******  CHANNEL *******//
    
    /** Notifica que um novo canal foi criado com voce */
    case channel_new = "channel_new"

    /** Cria um novo canal contendo um vetor de id`s de sessao com cada usuario
     que estará presente nesse canal */
    case channel_create = "channel_create"
    
    /** Adiciona um novo participante ao canal */
    case channel_add = "channel_add"
    
    /** Sai de um canal o qual voce esta presente */
    case channel_quit = "channel_quit"
    
    /** Uma sessao saiu do canal */
    case channel_quitted = "channel_quitted"
    
    /** Uma nova sessao entrou em um canal */
    case channel_member = "channel_member"
    
    /** Renomeia um canal */
    case channel_rename = "channel_rename"
    
    /** Um canal foi renomeado */
    case channel_renamed = "channel_renamed"
    
    /** Derruba um canal, ou seja, deleta */
    case channel_drop = "channel_drop"
    
    /** Um canal foi derrubado */
    case channel_dropped = "channel_dropped"
    
    
    //*******  USER BEHAVIORS *******//

    /** Notifica que um usuario com uma sessao i esta online */
    case user_online = "user_online"
    
    /** Notifica que um usuario esta escrevendo em um canal especifico */
    case user_typing = "user_typing"
    
    /** Notifica que um usuario esta desconectado */
    case user_offline = "user_offline"
    
    /** Notifica que um usuario nao esta mais digitando */
    case user_stopped = "user_stopped"
    
    //*******  MESSAGES  *******//

    /** Notificacao de nova mensagem recebida */
    case message_send = "message_send"
    
    /** nova mensagem */
    case message_new = "message_new"
    
    /** Envia e recebe uma notificacao de que uma mensagem foi vista */
    case message_seen = "message_seen"
    
    /** Deleta uma mensagem */
    case message_delete = "message_delete"
    
    /** Recebe uma notificacao de que uma mensagem foi deletada */
    case message_deleted = "message_deleted"
    

    


}
