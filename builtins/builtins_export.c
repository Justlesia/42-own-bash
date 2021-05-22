/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   builtins_export.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sbrenton <sbrenton@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/04/24 13:39:09 by sbrenton          #+#    #+#             */
/*   Updated: 2021/05/16 16:33:26 by sbrenton         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../minibash.h"

int	check_is_valid(t_seq *tmp_seq, int i, int flag)
{
	int	n;

	n = 0;
	if ((tmp_seq->args[i][0] == '_') ||
		(tmp_seq->args[i][0] >= 'a' && tmp_seq->args[i][0] <= 'z') ||
		(tmp_seq->args[i][0] >= 'A' && tmp_seq->args[i][0] <= 'Z'))
		n++;
	else
	{
		if (!flag)
			printf("export: `%s': not a valid identifier\n", tmp_seq->args[i]);
		return (2);
	}
	while (tmp_seq->args[i][n] != 0 && tmp_seq->args[i][n] != '=')
	{
		if ((tmp_seq->args[i][n] == '_') || (tmp_seq->args[i][n] == '\n') ||
			(tmp_seq->args[i][n] >= 'a' && tmp_seq->args[i][n] <= 'z') ||
			(tmp_seq->args[i][n] >= 'A' && tmp_seq->args[i][n] <= 'Z') ||
			(tmp_seq->args[i][n] >= '0' && tmp_seq->args[i][n] <= '9'))
			n++;
		else
		{
			if (!flag)
				printf("export: `%s': not a valid identifier\n", tmp_seq->args[i]);
			return (2);
		}
	}
	return (0);
}

int	builtins_export(t_shell *shell, t_seq *tmp_seq, char *str_low, int flag)
{

	char	*value;
	char	*param;
	int		i;

	if (!flag && redir(tmp_seq, &str_low, 0))
		return (2);
	g_ret_status = 0;
	if (!flag && (tmp_seq->args[1] == 0 || tmp_seq->args[1][0] == '\n'))
		return (print_export(shell));
	i = 1;
	while (tmp_seq->args[i] != 0)
	{
		value = NULL;
		param = NULL;
		if (check_is_valid(tmp_seq, i, flag) == 2)
		{
			g_ret_status = 1;
			i++;
			continue;
		}
		pair_param_value(tmp_seq, i, &param, &value);
		if ((value == NULL && envp_get_value(shell, param) != NULL)
			|| (envp_set_value(shell, param, value) == 0))
		{
			free(value);
			free(param);
		}
		else
			envp_new_value(shell, param, value);
		i++;
	}
	if (!flag)
		redir(tmp_seq, &str_low, 2);
	return (g_ret_status);
}
