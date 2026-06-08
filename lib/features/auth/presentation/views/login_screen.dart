import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../session/presentation/viewmodels/session_viewmodel.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    ref.read(loginViewModelProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (prev, next) {
      if (next.status == LoginStatus.success) {
        // Inicia el "timer de uso": genera el token y lo guarda junto con la
        // variable de tiempo en el almacén encriptado.
        ref.read(sessionViewModelProvider.notifier).startSession();
        context.go(RouteNames.teacherGroup);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBlobDecoration(),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildLogo(),
                        const SizedBox(height: 48),
                        _buildHeader(),
                        const SizedBox(height: 36),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 12),
                        _buildForgotPassword(),
                        if (state.status == LoginStatus.error) ...[
                          const SizedBox(height: 12),
                          _buildErrorMessage(state.errorMessage ?? ''),
                        ],
                        const SizedBox(height: 28),
                        _buildLoginButton(state),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlobDecoration() {
    return Positioned(
      top: -30,
      right: -40,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.psychology_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Cogni',
                style: TextStyle(
                  color: AppColors.inkDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Fit',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bienvenida\nde regreso',
          style: TextStyle(
            color: AppColors.inkDark,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ingresa con tu correo institucional para continuar\nel seguimiento de tu grupo.',
          style: TextStyle(
            color: AppColors.inkLight,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Correo institucional',
          style: TextStyle(
            color: AppColors.inkDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: AppColors.inkDark, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'docente@sep.gob.mx',
            hintStyle: TextStyle(color: AppColors.inkLight),
            prefixIcon: const Icon(
              Icons.alternate_email_rounded,
              color: AppColors.inkLight,
              size: 20,
            ),
          ),
          onChanged: (_) {
            if (ref.read(loginViewModelProvider).status == LoginStatus.error) {
              ref.read(loginViewModelProvider.notifier).resetError();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            color: AppColors.inkDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: AppColors.inkDark, fontSize: 15),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: AppColors.inkLight),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.inkLight,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.inkLight,
                size: 20,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          onChanged: (_) {
            if (ref.read(loginViewModelProvider).status == LoginStatus.error) {
              ref.read(loginViewModelProvider.notifier).resetError();
            }
          },
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.riskRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.riskRed, size: 16),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.riskRed,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginState state) {
    final isLoading = state.status == LoginStatus.loading;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onLoginPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Entrar'),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppColors.inkLight, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.inkLight,
                  fontSize: 12,
                  height: 1.5,
                ),
                children: const [
                  TextSpan(text: '¿Problemas para ingresar? '),
                  TextSpan(
                    text: 'Contacta a tu coordinador',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkMedium,
                    ),
                  ),
                  TextSpan(text: ' académico para revisar tu acceso.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
