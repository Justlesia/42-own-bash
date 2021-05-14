/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   builtins_cd.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: cgriceld <cgriceld@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2021/04/27 22:39:21 by sbrenton          #+#    #+#             */
/*   Updated: 2021/05/14 16:27:38 by cgriceld         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../minibash.h"

char	*find_path(t_shell *shell, char *path, char *match)
{
	path = envp_get_value(shell, match);
	if (!path)
	{
		write(2, "cd: ", 4);
		write(2, match, ft_strlen(match));
		write(2, ": not set\n", 10);
		//printf("cd: %s not set\n", match);
		ret_status = 1;
		return (NULL);
	}
	return (path);
}

void	update_pwd(t_shell *shell, char *path, char *old_path, t_seq *tmp_seq)
{
//	if (is_oldpwd == 0)
//	{
//		if (envp_get_value(shell, "OLDPWD") == NULL)
//			envp_new_value(shell, ft_strdup("OLDPWD"), NULL);
//		is_oldpwd = 1;
//	}
	//free(path);
	path = pwd(shell, tmp_seq);
	if (ft_strncmp(old_path, path, ft_strlen(old_path + 1)) != 0)
	{
		envp_set_value(shell, "OLDPWD", old_path);
		envp_set_value(shell, "PWD", path);
	}
	free(old_path);
	free(path);
}

// более 25 строк
int		builtins_cd(t_shell *shell, t_seq *tmp_seq, char *str_low)
{
	char	*path;
	char	*old_path;
	char	*param;
	
	if (redir(shell, tmp_seq, &str_low, 1))
		return (1);
	ret_status = 0;
	param = tmp_seq->args[1];
	old_path = pwd(shell, tmp_seq);
	if (!old_path)
		return (1);
	if (!param || (ft_strncmp(param, "", 1) == 0))
		path = find_path(shell, path, "HOME");
	else if (ft_strncmp(param, "-", 2) == 0)
		path = find_path(shell, path, "OLDPWD");
	else
		path = param;
	if (path && ret_status == 0 && chdir(path) != 0)
	{
		write(2, "cd: ", 4);
		write(2, param, ft_strlen(param));
		write(2, ": No such file or directory\n", 28);
		ret_status = 1;
	}
	if (ret_status == 0)
		update_pwd(shell, path, old_path, tmp_seq);
	return (ret_status);
}
